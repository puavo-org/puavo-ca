require 'puavo/etc'

class CertificatesController < ApplicationController
  before_action :require_http_auth_user, :except => [ :orgcabundle, :rootca ]

  # GET /certificates/rootca.text
  def rootca
    return render_badparam('bad format in version parameter') \
      unless params[:version].nil? || params[:version].match(/\A\d+\z/)

    respond_to do |format|
      format.text do
        send_data(get_rootca(params[:version]), :type => 'text/plain')
      end
    end
  end

  # GET /certificates/orgcabundle.text
  def orgcabundle
    org = params[:org]
    return render_badparam('bad format in organisation parameter') \
      unless org.match(/\A\w+\z/)

    version = params[:version]
    return render_badparam('bad format in version parameter') \
      unless version.nil? || version.match(/\A\d+\z/)

    respond_to do |format|
      format.text do
        send_data(get_org_ca_certificate_bundle(org, version),
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
        format.json { render :json => '404 Not Found', :status => :not_found }
      else
        format.json { render :json => { 'certificates' => certificates } }
      end
    end
  end

  # POST /certificates.json
  def create
    return render_badparam('bad format in organisation parameter') \
      unless params[:org].match(/\A\w+\z/)
    params[:version] = version_or_default(params[:version]) \
      if params[:version].nil?

    certificate = Certificate.new(certificate_params)
   
    respond_to do |format|
      if certificate.save then
        format.json do
          org_ca_certificate_bundle \
            = get_org_ca_certificate_bundle(params[:org], params[:version])
          render :json => {
            'certificate'               => certificate,
            'org_ca_certificate_bundle' => org_ca_certificate_bundle,
            'root_ca_certificate'       => get_rootca(params[:version]),
          }, :status => :created
        end
      else
        format.json do
          render :json   => certificate.errors,
                 :status => :unprocessable_entity
        end
      end
    end
  end

  # DELETE /certificates/1.json
  def revoke
    where_args = { :fqdn => params[:fqdn], :revoked => false }
    where_args[:version] = params[:version] unless params[:version].nil?

    certificates_to_revoke = Certificate.where(where_args)
    certificates_to_revoke.each do |cert|
      cert.revoked      = true
      cert.revoked_at   = Time.now
      cert.revoked_user = session[:dn]
      cert.save!
    end

    respond_to do |format|
      if certificates_to_revoke.empty? then
        format.json { render :json => '404 Not Found', :status => :not_found }
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
      render :json   => { :error => 'internal-server-error'}.to_json,
             :status => 500
    end
  end

  private

  def certificate_params
    params.require(:certificate).permit(:fqdn,
                                        :host_certificate_request,
                                        :organisation,
                                        :version)
  end

  def get_cert(cert_subpath, maybe_version)
    version = version_or_default(maybe_version)

    certdir  = "#{ PUAVO_CONFIG['certdirpath'] }/#{ version }"
    certpath = "#{ certdir }/#{ cert_subpath }"
    File.read(certpath)
  end

  def get_org_ca_certificate_bundle(org, version)
    topdomain = PUAVO_ETC.topdomain
    cert_subpath = "organisations/ca.#{ org }.#{ topdomain }-bundle.pem"
    get_cert(cert_subpath, version)
  end

  def get_rootca(version)
    get_cert("rootca/ca.#{ PUAVO_ETC.topdomain }.crt", version)
  end

  def render_badparam(errmsg)
    render :json   => { :error => errmsg }.to_json,
           :status => 400
  end

  def version_or_default(maybe_version)
    return maybe_version if maybe_version
    version = PUAVO_CONFIG['default_certchain_version']
    raise 'no certchain version' if version.nil?
    return version
  end
end
