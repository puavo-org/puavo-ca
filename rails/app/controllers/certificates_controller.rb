require 'puavo/etc'

class CertificatesController < ApplicationController
  before_action :require_http_auth_user, :except => [ :orgcabundle, :rootca ]

  # GET /certificates/rootca.text
  def rootca
    version = params[:version]
    return render_badparam('bad format in version parameter') \
      unless version.nil? || version.match(/\A\d+\z/)

    cert_subpath = "rootca/ca.#{ PUAVO_ETC.topdomain }.crt"

    respond_to do |format|
      format.text do
        send_data(get_cert(cert_subpath, version),
                  :type => 'text/plain')
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

    topdomain = PUAVO_ETC.topdomain
    cert_subpath = "organisations/ca.#{ org }.#{ topdomain }-bundle.pem"

    respond_to do |format|
      format.text do
        send_data(get_cert(cert_subpath, version),
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
    @certificate = Certificate.new(certificate_params)
    @certificate.organisation = organisation if organisation
    
    respond_to do |format|
      if @certificate.save
        format.json do
          render :json   => { 'certificate' => @certificate },
                 :status => :created
        end
      else
        format.json do
          render :json   => @certificate.errors,
                 :status => :unprocessable_entity
        end
      end
    end
  end

  # DELETE /certificates/1.json
  def revoke
    if @certificate = Certificate.find_by_fqdn_and_revoked(params[:fqdn], false)
      @certificate.revoked = true
      @certificate.revoked_at = Time.now
      @certificate.revoked_user = session[:dn]
      @certificate.save
    end

    respond_to do |format|
      if @certificate
        format.json { head :ok }
      else
        format.json { render :json => '404 Not Found', :status => :not_found }
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
    params.require(:certificate).permit(:fqdn, :host_certificate_request)
  end

  def get_cert(cert_subpath, version)
    if version.nil? then
      version = PUAVO_CONFIG['default_certchain_version']
      raise 'no certchain version' if version.nil?
    end

    certdir  = "#{ PUAVO_CONFIG['certdirpath'] }/#{ version }"
    certpath = "#{ certdir }/#{ cert_subpath }"
    File.read(certpath)
  end

  def render_badparam(errmsg)
    render :json   => { :error => errmsg }.to_json,
           :status => 400
  end
end
