require 'openssl'

class Certificate < ActiveRecord::Base
  attr_accessor :host_certificate_request
  before_create :sign_certificate

  validates :fqdn, :presence => true,
                   :uniqueness => { :scope => [ :revoked, :version ] },
                   :unless     => Proc.new { |cert| cert.revoked }
  validates :organisation, :presence => true
  validates :version, :format => { with: /\A\d+\z/ }, :presence => true

  def sign_certificate
    raise 'no such certificate chain version' \
      unless File.directory?(versioned_certdir)

    self.serial_number \
      = Certificate.where(:organisation => self.organisation) \
                   .maximum(:serial_number).to_i + 1
    csr = OpenSSL::X509::Request.new(self.host_certificate_request)
    hostname, *domain_a = self.fqdn.split('.')
    domain              = domain_a.join('.')

    begin
      sub_ca_cert_txt = get_org_ca_file(domain, 'crt')
      sub_ca_key_txt  = get_org_ca_file(domain, 'key')
    rescue StandardError => e
      raise 'could not read organisation certificates for certificate chain' \
              + " version #{ self.version }: #{ e.message }"
    end

    sub_ca_cert = OpenSSL::X509::Certificate.new(sub_ca_cert_txt)
    sub_ca_key  = OpenSSL::PKey::RSA.new(sub_ca_key_txt)

    cert = OpenSSL::X509::Certificate.new
    cert.subject = OpenSSL::X509::Name.new(
		     [[ 'CN', "#{ hostname }.#{ domain }" ]])

    cert.not_after  = Time.now + 3 * 365 * 24 * 60 * 60
    cert.not_before = Time.now - 24 * 60 * 60
    cert.serial     = self.serial_number
    cert.version    = 2

    cert.public_key = csr.public_key
    cert.issuer = sub_ca_cert.subject

    ext_factory = OpenSSL::X509::ExtensionFactory.new
    ext_factory.subject_certificate = cert
    ext_factory.issuer_certificate  = sub_ca_cert

    cert.extensions = [
      ext_factory.create_extension('basicConstraints', 'CA:FALSE', true),
      ext_factory.create_extension('subjectAltName', "DNS:#{ hostname }.#{ domain }"),
      ext_factory.create_extension('subjectKeyIdentifier', 'hash'),
      ext_factory.create_extension('keyUsage',
				   'digitalSignature,keyEncipherment'),
      ext_factory.create_extension('extendedKeyUsage',
				   'serverAuth,clientAuth,emailProtection'),
    ]

    cert.sign(sub_ca_key, OpenSSL::Digest::SHA512.new)
    self.certificate = cert.to_pem
  end

private
  def versioned_certdir
    File.join(PUAVO_CONFIG['certdirpath'], self.version)
  end

  def get_org_ca_file(domain, suffix)
    organisation_ca_file_path = File.join(versioned_certdir,
                                          'organisations',
                                          "ca.#{ domain }.#{ suffix }")
    return File.read(organisation_ca_file_path)
  end
end
