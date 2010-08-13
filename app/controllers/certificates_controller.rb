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
    @certificate = Certificate.find(params[:id])
    @certificate.revoked = true
    @certificate.revoked_at = Time.now
    @certificate.revoked_user = session[:dn]
    @certificate.save

    respond_to do |format|
      format.json  { head :ok }
    end
  end
end
