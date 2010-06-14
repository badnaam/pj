class MerchantsController < ApplicationController
    # GET /merchants
    # GET /merchants.xml
    layout 'users'
    #    geocode_ip_address
    #    before_filter :init_search, :only => [:index]
    #    filter_resource_access :only => [:create, :edit, :update, :new]


    def process_votes
        @vote_topic = VoteTopic.find_by_active_and_merchant_id(true, params[:id], :include => :vote_items)
        if !@vote_topic.nil?
            @vote_items = @vote_topic.vote_items
            @vote_items.each do |v|
                if params[v.id.to_s] == "yes"
                    current_user.vote_for(v)
                else
                    current_user.vote_against(v)
                end
            end
        end
        respond_to do |format|
            format.html
            format.js
        end
    end
    
    def rate
        @merchant = Merchant.find(params[:id])
        @merchant.rate(params[:stars], current_user, params[:dimension])
        render :update do |page|
            page.replace_html @merchant.wrapper_dom_id(params), ratings_for(@merchant, params.merge(:wrap => false))
            page.visual_effect :highlight, @merchant.wrapper_dom_id(params)
        end
    end
    
    def index
        unless !cookies[:geo_loc].nil? || !cookies[:geo_loc].blank?
            @geo = cookies[:geo_loc]
        else
            @geo = Search::DEFAULT_LOCATION
        end
        @latest = Merchant.origin(@geo).within(Search::DEFAULT_WITHIN).descend_by_created_at.all(:limit => 10)
        @highest = Merchant.gcertificates_cert_valid(true).descend_by_gcertificates_total_score.origin(@geo).within(Search::DEFAULT_WITHIN).all(:limit => 10)
        @most_members = Merchant.origin(@geo).within(Search::DEFAULT_WITHIN).descend_by_merchant_memberships_count.all(:limit => 10)
        @highest_prod_srvc = Merchant.origin(@geo).within(Search::DEFAULT_WITHIN).descend_by_rating_average_quality.all(:limit => 10)
        @active_votes = Merchant.vote_topics_active_equals(true).origin(@geo).within(Search::DEFAULT_WITHIN).all(:limit => 10)
        @top_offers = Offer.origin(@geo).within(Search::DEFAULT_WITHIN).descend_by_created_at.all(:limit => 100)
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @merchants }
            format.js
        end
    end

    def get_m_reward
        @merchant = Merchant.find(params[:id])
    end
    
    # GET /merchants/1
    # GET /merchants/1.xml
    def show
        @merchant = Merchant.find(params[:id], :include => [:gcertificates, :gcertifications, :merchant_category])
        @vote_topic = @merchant.vote_topics.find_by_active(true, :include => :vote_items)
        if !@vote_topic.nil?
            @vote_items = @vote_topic.vote_items
        end
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @merchant }
        end
    end

    # GET /merchants/new
    # GET /merchants/new.xml
    def new
        @merchant = current_user.owned_merchants.build
        #        @address = @merchant.build_address
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @merchant }
        end
    end

    # GET /merchants/1/edit
    def edit
        @merchant = Merchant.find(params[:id])
    end

    # POST /merchants
    # POST /merchants.xml
    def create
        @merchant = current_user.owned_merchants.create(params[:merchant])
        #        @merchant.owner_id = current_user.id
        
        respond_to do |format|
            if @merchant.save
                flash[:notice] = t('merchant.create_success')
                format.html { redirect_to(@merchant) }
                format.xml  { render :xml => @merchant, :status => :created, :location => @merchant }
            else
                flash[:notice] = t('merchant.create_failed')
                format.html { render :action => 'new' }
                format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /merchants/1
    # PUT /merchants/1.xml
    def update
        @merchant = Merchant.find(params[:id])

        respond_to do |format|
            if @merchant.update_attributes(params[:merchant])
                flash[:notice] = 'Merchant was successfully updated.'
                format.html { redirect_to(@merchant) }
                format.xml  { head :ok }
            else
                format.html { render :action => 'edit' }
                format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /merchants/1
    # DELETE /merchants/1.xml
    def destroy
        @merchant = Merchant.find(params[:id])
        @merchant.destroy

        respond_to do |format|
            format.html { redirect_to(merchants_url) }
            format.xml  { head :ok }
        end
    end

    
    def find_association_name
        params.each do |name, value|
            if name =~ /(.+)_id$/
                return $1
            end
        end
    end

    def find_association
        params.each do |name, value|
            if name =~ /(.+)_id$/
                return $1.classify.constantize.find(value)
            end
        end
    end
end
