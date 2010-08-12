class CertificatesController < ApplicationController
  # GET /certificates
  # GET /certificates.xml
  def index
    @certificates = Certificate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @certificates }
      format.json  { render :json => @certificates }
    end
  end

  # GET /certificates/1
  # GET /certificates/1.xml
  def show
    @certificate = Certificate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @certificate }
    end
  end

  # GET /certificates/new
  # GET /certificates/new.xml
  def new
    @certificate = Certificate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @certificate }
    end
  end

  # GET /certificates/1/edit
  def edit
    @certificate = Certificate.find(params[:id])
  end

  # POST /certificates
  # POST /certificates.xml
  def create
    @certificate = Certificate.new(params[:certificate])
    @certificate.organisation = organisation if organisation
    
    respond_to do |format|
      if @certificate.save
        format.html { redirect_to(@certificate, :notice => 'Certificate was successfully created.') }
        format.xml  { render :xml => @certificate, :status => :created, :location => @certificate }
        format.json  { render :json => @certificate, :status => :created, :location => @certificate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @certificate.errors, :status => :unprocessable_entity }
        format.json  { render :json => @certificate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /certificates/1
  # PUT /certificates/1.xml
  def update
    @certificate = Certificate.find(params[:id])

    respond_to do |format|
      if @certificate.update_attributes(params[:certificate])
        format.html { redirect_to(@certificate, :notice => 'Certificate was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @certificate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /certificates/1
  # DELETE /certificates/1.xml
  def destroy
    @certificate = Certificate.find(params[:id])
    @certificate.destroy

    respond_to do |format|
      format.html { redirect_to(certificates_url) }
      format.xml  { head :ok }
    end
  end
end
