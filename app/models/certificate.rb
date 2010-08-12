require 'openssl'

class Certificate < ActiveRecord::Base
  attr_accessor :host_certificate_request
  before_create :sign_certificate

  validates_presence_of :organisation

  def sign_certificate
    csr = OpenSSL::X509::Request.new(self.host_certificate_request)
    hostname = csr.subject.to_s.sub(/\/CN=/i, '').downcase
    domain = self.fqdn.sub(/#{hostname}./i, '')

    # XXX should domain be hardwired?  that we won't sign random stuff?
    # XXX if so, where should the toplevel domain be configured?

    sub_ca_cert_path = "#{ PUAVO_CONFIG['certdirpath'] }/ca.#{ domain }.crt"
    sub_ca_cert_txt  = File.read(sub_ca_cert_path)
    sub_ca_cert      = OpenSSL::X509::Certificate.new(sub_ca_cert_txt)
    sub_ca_key       = key("ca.#{ domain }.key")

    cert = OpenSSL::X509::Certificate.new
    cert.subject = OpenSSL::X509::Name.new(
		     [[ 'CN', "#{ hostname }.#{ domain }" ]])

    cert.not_after  = Time.now - 3 * 365 * 24 * 60 * 60
    cert.not_before = Time.now - 24 * 60 * 60
    cert.serial     = 1		# XXX should increment,
				# XXX should be stored in database?
#   CertLib::CertSerial.number(:subject => cert.subject.to_s,
#                              :expires_after => cert.not_after.strftime("%Y-%m-%d %H:%M:%S"))
    cert.version = 2

    cert.public_key = csr.public_key
    cert.issuer = sub_ca_cert.subject

    ext_factory = OpenSSL::X509::ExtensionFactory.new
    ext_factory.subject_certificate = cert
    ext_factory.issuer_certificate  = sub_ca_cert

    cert.extensions = [
      ext_factory.create_extension('basicConstraints', 'CA:FALSE', true),
      ext_factory.create_extension('subjectAltName', 'DNS:ldap.opinsys.fi'),
      ext_factory.create_extension('subjectKeyIdentifier', 'hash'),
      ext_factory.create_extension('keyUsage',
				   'digitalSignature,keyEncipherment'),
      ext_factory.create_extension('extendedKeyUsage',
				   'serverAuth,clientAuth,emailProtection'),
    ]

    cert.sign(sub_ca_key, OpenSSL::Digest::SHA1.new)
    self.certificate = cert.to_pem
  end

private
  def key(name)
    key = File.read("#{ PUAVO_CONFIG['certdirpath'] }/#{ name }")
    OpenSSL::PKey::RSA.new(key)
  end
end
