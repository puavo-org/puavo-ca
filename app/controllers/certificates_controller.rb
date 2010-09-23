class CertificatesController < ApplicationController
  before_filter :require_http_auth_user, :except => :ca

  # GET /certificates/rootca.text
  def rootca
    @top_level_domain = PUAVO_CONFIG['certdirpath'].match(/([^\/]+)[\/]*$/)[1]

    respond_to do |format|
      format.text  { send_data( File.read("#{ PUAVO_CONFIG['certdirpath'] }/rootca/ca.#{ @top_level_domain }.crt"), :type => 'text/plain' ) }
    end
  end

  # GET /certificates/orgcabundle.text
  def orgcabundle
    @top_level_domain = PUAVO_CONFIG['certdirpath'].match(/([^\/]+)[\/]*$/)[1]

    respond_to do |format|
      format.text  { send_data( File.read("#{ PUAVO_CONFIG['certdirpath'] }/organisations/ca.#{ params[:org] }.#{ @top_level_domain }-bundle.pem"), :type => 'text/plain' ) }
    end
  end

  # GET /certificates.json
  def index
    @certificates = Certificate.all

    respond_to do |format|
      format.json  { render :json => @certificates }
    end
  end

  # GET /certificates/revoked_list.json
  def revoked_list
    @certificates = Certificate.where(:revoked => true)
    
    respond_to do |format|
      format.json  { render :json => @certificates }
    end
  end

  # GET /certificates/1.json
  def show
    @certificate = Certificate.find(params[:id])

    respond_to do |format|
      format.json  { render :json => @certificate }
    end
  end

  # GET /certificates/show_by_fqdn.json
  def show_by_fqdn
    @certificate = Certificate.find_by_fqdn_and_revoked(params[:fqdn], false)

    respond_to do |format|
      if @certificate
        format.json  { render :json => @certificate }
      else
        format.json  { render :json => "404 Not Found", :status => :not_found }
      end
    end
  end

  # POST /certificates.json
  def create
    @certificate = Certificate.new(params[:certificate])
    @certificate.organisation = organisation if organisation
    
    respond_to do |format|
      if @certificate.save
        format.json  { render :json => @certificate, :status => :created, :location => @certificate }
      else
        format.json  { render :json => @certificate.errors, :status => :unprocessable_entity }
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
        format.json  { head :ok }
      else
        format.json  { render :json => "404 Not Found", :status => :not_found }
      end
    end
  end
end
