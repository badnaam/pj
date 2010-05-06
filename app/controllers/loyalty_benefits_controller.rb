class LoyaltyBenefitsController < ApplicationController
    layout "users"
    
    #    before_filter :load_merchant, :only => [:index]
    #    before_filter :new_lb, :only => [:new]
    #    before_filter :create_lb, :only => [:create]

    #    filter_access_to :index, :attribute_check => true, :load_method => :load_merchant
    #    filter_access_to :new, :attribute_check => true, :load_method => :new_lb
    #    filter_access_to :create, :attribute_check => true, :load_method => :create_lb
    
    
    # GET /loyalty_benefits
    # GET /loyalty_benefits.xml
    def index
        @merchant ||= Merchant.find(params[:merchant_id])
        @loyalty_benefits = @merchant.loyalty_benefits.all
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @loyalty_benefits }
        end
    end

    # GET /loyalty_benefits/1
    # GET /loyalty_benefits/1.xml
    def show
        @merchant ||= Merchant.find(params[:merchant_id])
        @loyalty_benefit = @merchant.loyalty_benefits.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @loyalty_benefit }
        end
    end

    # GET /loyalty_benefits/new
    # GET /loyalty_benefits/new.xml
    def new
        @merchant ||= Merchant.find(params[:merchant_id])
        @loyalty_benefit = @merchant.loyalty_benefits.new
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @loyalty_benefit }
        end
    end

    # GET /loyalty_benefits/1/edit
    def edit
        @merchant ||= Merchant.find(params[:merchant_id])
        @loyalty_benefit = @merchant.loyalty_benefits.find(params[:id])
    end

    # POST /loyalty_benefits
    # POST /loyalty_benefits.xml
    def create
        #        @loyalty_benefit = LoyaltyBenefit.new(params[:loyalty_benefit])
        @merchant ||= Merchant.find(params[:merchant_id])
        @loyalty_benefit ||= @merchant.loyalty_benefits.build(params[:loyalty_benefit])
        @loyalty_benefit.user_id = current_user.id
        
        respond_to do |format|
            if @loyalty_benefit.save
                flash[:notice] = 'LoyaltyBenefit was successfully created.'
                format.html { redirect_to(merchant_loyalty_benefits_path) }
                format.xml  { render :xml => @loyalty_benefit, :status => :created, :location => @loyalty_benefit }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @loyalty_benefit.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /loyalty_benefits/1
    # PUT /loyalty_benefits/1.xml
    def update
        @merchant ||= Merchant.find(params[:merchant_id])
        @loyalty_benefit = @merchant.loyalty_benefits.find(params[:id])

        respond_to do |format|
            if @loyalty_benefit.update_attributes(params[:loyalty_benefit])
                flash[:success] = 'LoyaltyBenefit was successfully updated.'
                format.html { redirect_to(merchant_loyalty_benefits_path(@merchant)) }
                format.xml  { head :ok }
            else
                flash[:error] = "Error updating program details"
                format.html { render :action => "edit" }
                format.xml  { render :xml => @loyalty_benefit.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /loyalty_benefits/1
    # DELETE /loyalty_benefits/1.xml
    def destroy
        @loyalty_benefit = LoyaltyBenefit.find(params[:id])
        @loyalty_benefit.destroy

        respond_to do |format|
            format.html { redirect_to(merchant_loyalty_benefits_path) }
            format.xml  { head :ok }
        end
    end

    protected

    def load_merchant
        @merchant = Merchant.find(params[:merchant_id])
    end

    def new_lb
        @merchant = Merchant.find(params[:merchant_id])
        @loyalty_benefit = @merchant.loyalty_benefits.new
    end

    def create_lb
        @merchant = Merchant.find(params[:merchant_id])
        @loyalty_benefit = @merchant.loyalty_benefits.build(params[:loyalty_benefits])
    end
end
