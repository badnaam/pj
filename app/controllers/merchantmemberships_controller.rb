class MerchantmembershipsController < ApplicationController
    # GET /merchantmemberships
    # GET /merchantmemberships.xml
    def index
        @merchantmemberships = Merchantmembership.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @merchantmemberships }
        end
    end

    # GET /merchantmemberships/1
    # GET /merchantmemberships/1.xml
    def show
        @merchantmembership = Merchantmembership.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @merchantmembership }
        end
    end

    # GET /merchantmemberships/new
    # GET /merchantmemberships/new.xml
    def new
        @merchantmembership = Merchantmembership.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @merchantmembership }
        end
    end

    # GET /merchantmemberships/1/edit
    def edit
        @merchantmembership = Merchantmembership.find(params[:id])
    end

    # POST /merchantmemberships
    # POST /merchantmemberships.xml
    def create
        @u = current_user
        @m = Merchant.find(params[:merchant_id])
        if (@u.id != @m.owner_id)
            attribs = Hash.new
            attribs[:total_points] = 0
            attribs[:level] = LoyaltyBenefit::LEVEL_OPTIONS.first[0]
            attribs[:user_id] = @u.id
            @merchantmembership = @m.merchant_memberships.create(attribs)
        else
            flash[:notice] = "Merchant can't be member of their own business"
        end
        respond_to do |format|
            if @merchantmembership != nil
                if @merchantmembership.save
                    flash[:notice] = 'You are now a member of ' + @m.name + ' Eco-Points program!'
                    format.html { redirect_to(@merchantmembership) }
                    format.xml  { render :xml => @merchantmembership, :status => :created, :location => @merchantmembership }
                    format.js
                else
                    flash[:error] = "Error registering new membership"
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @merchantmembership.errors, :status => :unprocessable_entity }
                    format.js
                end
            end
        end
    end

    # PUT /merchantmemberships/1
    # PUT /merchantmemberships/1.xml
    def update
        @merchantmembership = Merchantmembership.find(params[:id])

        respond_to do |format|
            if @merchantmembership.update_attributes(params[:merchantmembership])
                flash[:notice] = 'Merchantmembership was successfully updated.'
                format.html { redirect_to(@merchantmembership) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @merchantmembership.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /merchantmemberships/1
    # DELETE /merchantmemberships/1.xml
    def destroy
        @merchantmembership = Merchantmembership.find(params[:id])
        @merchantmembership.destroy

        respond_to do |format|
            format.html { redirect_to(merchantmemberships_url) }
            format.xml  { head :ok }
        end
    end
end
