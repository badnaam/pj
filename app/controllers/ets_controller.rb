class EtsController < ApplicationController
    layout "users"
    # GET /ets
    # GET /ets.xml
    def index
        @ets = Et.all

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @ets }
        end
    end

    # GET /ets/1
    # GET /ets/1.xml
    def show
        @et = Et.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @et }
        end
    end

    # GET /ets/new
    # GET /ets/new.xml
    def new
        @et = Et.new
        if current_role == "business"
            @et.merchant_id = Merchant.find_by_owner_id(current_user.id).id
        end
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @et }
        end
    end

    # GET /ets/1/edit
    def edit
        @et = Et.find(params[:id])
    end

    # POST /ets
    # POST /ets.xml
    def create
        u = User.find_by_username(params[:username])
        if (u.blank?)
            flash[:error] = "Invalid username"
        else
            params[:et][:user_id] = u.id
#            Et.process_transaction(params[:et])
        end
        @et = Et.new(params[:et])

        respond_to do |format|
            if @et.save
                flash[:notice] = 'Transaction Successfull.'
                format.html { redirect_to(@et) }
                format.xml  { render :xml => @et, :status => :created, :location => @et }
            else
#                flash[:error] = "Failed to save transaction"
                format.html { render :action => "new" }
                format.xml  { render :xml => @et.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /ets/1
    # PUT /ets/1.xml
    def update
        @et = Et.find(params[:id])

        respond_to do |format|
            if @et.update_attributes(params[:et])
                flash[:notice] = 'Et was successfully updated.'
                format.html { redirect_to(@et) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @et.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /ets/1
    # DELETE /ets/1.xml
    def destroy
        @et = Et.find(params[:id])
        @et.destroy

        respond_to do |format|
            format.html { redirect_to(ets_url) }
            format.xml  { head :ok }
        end
    end
end
