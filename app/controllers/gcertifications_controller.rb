class GcertificationsController < ApplicationController
    layout "users"
  # GET /gcertifications
  # GET /gcertifications.xml
  def index
    @gcertifications = Gcertification.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gcertifications }
    end
  end

  # GET /gcertifications/1
  # GET /gcertifications/1.xml
  def show
    @gcertification = Gcertification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gcertification }
    end
  end

  # GET /gcertifications/new
  # GET /gcertifications/new.xml
  def new
    @gcertification = Gcertification.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gcertification }
    end
  end

  # GET /gcertifications/1/edit
  def edit
    @gcertification = Gcertification.find(params[:id])
  end

  # POST /gcertifications
  # POST /gcertifications.xml
  def create
    @gcertification = Gcertification.new(params[:gcertification])

    respond_to do |format|
      if @gcertification.save
        flash[:notice] = 'Gcertification was successfully created.'
        format.html { redirect_to(@gcertification) }
        format.xml  { render :xml => @gcertification, :status => :created, :location => @gcertification }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gcertification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gcertifications/1
  # PUT /gcertifications/1.xml
  def update
    @gcertification = Gcertification.find(params[:id])

    respond_to do |format|
      if @gcertification.update_attributes(params[:gcertification])
        flash[:notice] = 'Gcertification was successfully updated.'
        format.html { redirect_to(@gcertification) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gcertification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gcertifications/1
  # DELETE /gcertifications/1.xml
  def destroy
    @gcertification = Gcertification.find(params[:id])
    @gcertification.destroy

    respond_to do |format|
      format.html { redirect_to(gcertifications_url) }
      format.xml  { head :ok }
    end
  end
end
