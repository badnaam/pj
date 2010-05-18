class GcertstepsController < ApplicationController
    layout "users"
    filter_resource_access

    # GET /gcertsteps
    # GET /gcertsteps.xml
    def index
        unless params[:merchant_id].nil?
            mc = Merchant.find(params[:merchant_id]).merchant_categorizations.first.merchant_category
            unless mc.nil?
                @gcertsteps = mc.gcertsteps.all.paginate(:page => params[:page], :per_page => 5, :include => :certstep_merchant_categorizations, :order => :category_name)
            end
        else
            @gcertsteps = Gcertstep.all.paginate(:page => params[:page], :per_page => 5, :include => :certstep_merchant_categorizations, :order => :category_name)
        end
        respond_to do |format|
            format.html # index.html.erb
            format.js
            format.xml  { render :xml => @gcertsteps }
        end
    end

    def getsubcat
        @subcats = Gcertstep::CATEGORIES[params[:category_name]]
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
                format.html { redirect_to(gcertsteps_path) }
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
                format.html { redirect_to(gcertsteps_path) }
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
