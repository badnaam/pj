class GcertstepsController < ApplicationController
  # GET /gcertsteps
  # GET /gcertsteps.xml
  def index
    @gcertsteps = Gcertstep.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gcertsteps }
    end
  end

  # GET /gcertsteps/1
  # GET /gcertsteps/1.xml
  def show
    @gcertstep = Gcertstep.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gcertstep }
    end
  end

  # GET /gcertsteps/new
  # GET /gcertsteps/new.xml
  def new
    @gcertstep = Gcertstep.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gcertstep }
    end
  end

  # GET /gcertsteps/1/edit
  def edit
    @gcertstep = Gcertstep.find(params[:id])
  end

  # POST /gcertsteps
  # POST /gcertsteps.xml
  def create
    @gcertstep = Gcertstep.new(params[:gcertstep])

    respond_to do |format|
      if @gcertstep.save
        flash[:notice] = 'Gcertstep was successfully created.'
        format.html { redirect_to(@gcertstep) }
        format.xml  { render :xml => @gcertstep, :status => :created, :location => @gcertstep }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gcertstep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gcertsteps/1
  # PUT /gcertsteps/1.xml
  def update
    @gcertstep = Gcertstep.find(params[:id])

    respond_to do |format|
      if @gcertstep.update_attributes(params[:gcertstep])
        flash[:notice] = 'Gcertstep was successfully updated.'
        format.html { redirect_to(@gcertstep) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gcertstep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gcertsteps/1
  # DELETE /gcertsteps/1.xml
  def destroy
    @gcertstep = Gcertstep.find(params[:id])
    @gcertstep.destroy

    respond_to do |format|
      format.html { redirect_to(gcertsteps_url) }
      format.xml  { head :ok }
    end
  end
end
