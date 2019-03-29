require 'puavo/etc'

class CertificatesController < ApplicationController
  before_action :require_http_auth_user, :except => [:rootca, :orgcabundle]

  # GET /certificates/rootca.text
  def rootca

    respond_to do |format|
      format.text  { send_data( File.read("#{ PUAVO_CONFIG['certdirpath'] }/rootca/ca.#{ PUAVO_ETC.topdomain }.crt"), :type => 'text/plain' ) }
    end
  end

  # GET /certificates/orgcabundle.text
  def orgcabundle

    respond_to do |format|
      format.text  { send_data( File.read("#{ PUAVO_CONFIG['certdirpath'] }/organisations/ca.#{ params[:org] }.#{ PUAVO_ETC.topdomain}-bundle.pem"), :type => 'text/plain' ) }
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

  # DELETE /certificates/test_clean_up
  def test_clean_up
    if Rails.env.test?
      Certificate.find_all_by_organisation("example").each do |certificate|
        certificate.destroy
      end
      render :json => true
    else
      render :json => {:error => "internal-server-error"}.to_json, :status => 500
    end
  end
end
