class GcertificatesController < ApplicationController
    # GET /gcertificates
    # GET /gcertificates.xml
    layout "users"
    def index
        @gcertificates = Gcertificate.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @gcertificates }
        end
    end

    
    # GET /gcertificates/1
    # GET /gcertificates/1.xml
    def show
        @merchant = Merchant.find(params[:merchant_id])
        @gcertificate = @merchant.gcertificates(:order => ":id ASC").first
        if @gcertificate.nil?
            flash[:error] = "No Green Certificate set up"
        end
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @gcertificate }
        end
    end

    # GET /gcertificates/new
    # GET /gcertificates/new.xml
    def new
        @merchant_id = params[:merchant_id]
        m = Merchant.find(@merchant_id)
        unless m.nil?
            mc = m.merchant_category(:include => :gcertsteps) unless m.nil?
            @gcertsteps = mc.gcertsteps.group_by {|gs| gs.category_name}
            if @gcertsteps.size == 0
                flash[:notice] = t('gcertificate.no_certsteps_for_category')
            else
                @gcertificate = m.gcertificates.build
                @gcertifications = @gcertificate.gcertifications.build
            end
        end
        #        mc = MerchantCategory.find(m.merchant_category_id)
        respond_to do |format|
            unless @gcertificate.nil? && @gcertifications.nil?
                format.html # new.html.erb
                format.xml  { render :xml => @gcertificate }
            else
                format.html { redirect_to :back}
            end
        
        end
    end

    # GET /gcertificates/1/edit
    def edit
        @merchant = Merchant.find(params[:merchant_id])
        #get the latest gcertificate
#        @gcertificate = @merchant.gcertificates(:order => ":created_at DESC", :include => :gcertifications).first
        @gcertificate = @merchant.gcertificates.find_by_cert_valid(true, :include => :gcertifications)
        @gcertifications = @gcertificate.gcertifications.group_by {|gc| gc.gcertstep.category_name}
    end

    # POST /gcertificates
    # POST /gcertificates.xml
    def create
        @score = 0
        params[:gcertificate][:gcertifications_attributes].each do |k, v|
            @score += params[:gcertificate][:gcertifications_attributes][k][:score].to_i
        end
        params[:gcertificate][:grade] = Gcertificate.grade_it(@score)
        params[:gcertificate][:total_score] = @score
        @gcertificate = Gcertificate.new(params[:gcertificate])
        @merchant = Merchant.find(params[:gcertificate][:merchant_id])
        @gcertificate.cert_valid = true
        respond_to do |format|
            if @gcertificate.save
                flash[:notice] = 'Gcertificate was successfully created.'
                format.html { redirect_to(merchant_gcertificate_path(@merchant, @gcertificate)) }
                format.xml  { render :xml => @gcertificate, :status => :created, :location => @gcertificate }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @gcertificate.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /gcertificates/1
    # PUT /gcertificates/1.xml
    def update
        @gcertificate = Gcertificate.find(params[:id])
        @score = 0
        params[:gcertificate][:gcertifications_attributes].each do |k, v|
            @score += params[:gcertificate][:gcertifications_attributes][k][:score].to_i
        end
        @grade = Gcertificate.grade_it(@score)
        params[:gcertificate][:grade] = @grade
        params[:gcertificate][:total_score] = @score
        @merchant = Merchant.find(params[:gcertificate][:merchant_id])
        params[:gcertificate][:cert_valid] = true
        respond_to do |format|
            if @gcertificate.update_attributes(params[:gcertificate])
                flash[:notice] = 'Gcertificate was successfully updated.'
                format.html { redirect_to(merchant_gcertificate_path(@merchant)) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @gcertificate.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /gcertificates/1
    # DELETE /gcertificates/1.xml
    def destroy
        @gcertificate = Gcertificate.find(params[:id])
        @gcertificate.destroy

        respond_to do |format|
            format.html { redirect_to(gcertificates_url) }
            format.xml  { head :ok }
        end
    end
end
