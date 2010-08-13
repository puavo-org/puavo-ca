class CertificatesController < ApplicationController
  # GET /certificates.json
  def index
    @certificates = Certificate.all

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
