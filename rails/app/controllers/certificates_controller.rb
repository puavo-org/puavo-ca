require 'puavo/etc'

class CertificatesController < ApplicationController
  before_action :require_http_auth_user, :except => [ :orgcabundle, :rootca ]

  # GET /certificates/rootca.text
  def rootca
    return render_badparam('bad format in certchain_version parameter') \
      unless params[:certchain_version].nil? \
               || params[:certchain_version].match(/\A\d+\z/)

    respond_to do |format|
      format.text do
        send_data(get_rootca(params[:certchain_version]),
                             :type => 'text/plain')
      end
    end
  end

  # GET /certificates/orgcabundle.text
  def orgcabundle
    org = params[:org]
    return render_badparam('bad format in organisation parameter') \
      unless org.match(/\A\w+\z/)

    certchain_version = params[:certchain_version]
    return render_badparam('bad format in certchain_version parameter') \
      unless certchain_version.nil? || certchain_version.match(/\A\d+\z/)

    respond_to do |format|
      format.text do
        send_data(get_org_ca_certificate_bundle(org, certchain_version),
                  :type => 'text/plain')
      end
    end
  end

  # GET /certificates/show_by_fqdn.json
  def show_by_fqdn
    certificates = Certificate.where(:fqdn    => params[:fqdn],
                                     :revoked => false)
    respond_to do |format|
      if certificates.empty? then
        format.json do
          render :json   => { :error => 'certificates not found' },
                 :status => :not_found
        end
      else
        format.json { render :json => { :certificates => certificates } }
      end
    end
  end

  # POST /certificates.json
  def create
    return render_badparam('certificate parameter is missing') \
      unless params[:certificate]
    params[:certificate][:certchain_version] \
      = certchain_version_or_default(params[:certificate][:certchain_version])

    if @client_fqdn && @client_fqdn != params[:certificate][:fqdn] then
      render :json   => { :error => 'no permission (bad fqdn)' },
             :status => :unauthorized
      return
    end

    certificate = Certificate.new(certificate_params)

    respond_to do |format|
      if certificate.save then
        format.json do
          org_ca_certificate_bundle \
            = get_org_ca_certificate_bundle(certificate.organisation,
                                            certificate.certchain_version)
          render :json => {
            'certificate'               => certificate.certificate,
            'org_ca_certificate_bundle' => org_ca_certificate_bundle,
            'root_ca_certificate'       =>
              get_rootca(certificate.certchain_version),
          }, :status => :created
        end
      else
        format.json do
          errmsg = certificate.errors.full_messages.join(' / ')
          render :json   => { :error => errmsg },
                 :status => :unprocessable_entity
        end
      end
    end
  end

  # DELETE /certificates/1.json
  def revoke
    where_args = { :fqdn => params[:fqdn], :revoked => false }
    where_args[:certchain_version] = params[:certchain_version] \
       unless params[:certchain_version].nil?

    certificates_to_revoke = Certificate.where(where_args)
    certificates_to_revoke.each do |cert|
      cert.revoked      = true
      cert.revoked_at   = Time.now
      cert.revoked_user = session[:dn]
      cert.save!
    end

    respond_to do |format|
      if certificates_to_revoke.empty? then
        format.json do
          render :json   => { :error => 'certificates not found' },
                 :status => :not_found
        end
      else
        format.json { head :ok }
      end
    end
  end

  # DELETE /certificates/test_clean_up
  def test_clean_up
    if Rails.env.test?
      Certificate.find_all_by_organisation('example').each do |certificate|
        certificate.destroy
      end
      render :json => true
    else
      render :json   => { :error => 'internal-server-error' },
             :status => 500
    end
  end

  private

  def certificate_params
    params.require(:certificate).permit(:fqdn,
                                        :certchain_version,
                                        :host_certificate_request,
                                        :organisation)
  end

  def get_cert(cert_subpath, maybe_certchain_version)
    certchain_version = certchain_version_or_default(maybe_certchain_version)

    certdir  = "#{ PUAVO_CONFIG['certdirpath'] }/#{ certchain_version }"
    certpath = "#{ certdir }/#{ cert_subpath }"
    File.read(certpath)
  end

  def get_org_ca_certificate_bundle(org, certchain_version)
    topdomain = PUAVO_ETC.topdomain
    cert_subpath = "organisations/ca.#{ org }.#{ topdomain }-bundle.pem"
    get_cert(cert_subpath, certchain_version)
  end

  def get_rootca(certchain_version)
    get_cert("rootca/ca.#{ PUAVO_ETC.topdomain }.crt", certchain_version)
  end

  def render_badparam(errmsg)
    render :json   => { :error => errmsg }.to_json,
           :status => 400
  end

  def certchain_version_or_default(maybe_certchain_version)
    return maybe_certchain_version if maybe_certchain_version
    certchain_version = PUAVO_CONFIG['default_certchain_version']
    raise 'no certchain version' if certchain_version.nil?
    return certchain_version
  end
end
