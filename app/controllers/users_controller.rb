class UsersController < ApplicationController
    filter_resource_access :additional_member => {:deactivate => :update, :find => :show}
    #    session :cookie_only => false, :only => :create
    # GET /users.xml
    layout "wo_r_nav"
    
    def index
        @users = User.search(params[:search])
    end

    
    # GET /users/1
    # GET /users/1.xml
    def show
        @user = User.find(params[:id])
        @role = @user.role
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @user }
        end
    end

    # GET /users/new
    # GET /users/new.xml
    def new
        @user = User.new
        if params[:reg] == "b" # business user
            @user.ut = User::USER_TYPE["b"]
        elsif params[:reg] == "c"
            @user.ut = User::USER_TYPE["c"]
        else
            @user.ut = User::USER_TYPE["u"]
        end
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @user }
        end
    end

    # GET /users/1/edit
    def edit
        @user = User.find(params[:id])
    end

    # POST /users
    # POST /users.xml
    def create
        @user = User.new(params[:user])

        respond_to do |format|
            v = verify_recaptcha(:model => @user, :message => "Image verification failure!")
            if v && @user.save_without_session_maintenance
#                system "rake send_act_in_email user=#{@user} &"
                @user.send_later :deliver_activation_instructions!
                flash[:notice] = 'Your account has been created and a confirmation request has been sent to your email address.'
                format.html { redirect_to root_url }
                format.xml  { render :xml => @user, :status => :created, :location => @user }
            else
                format.html {
#                    @user = User.new
                    @user.ut = params[:user][:ut]
                    render :action => "new" }
                format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /users/1
    #     PUT /users/1.xml
    def update
        @user = User.find(params[:id])

        respond_to do |format|
            if @user.update_attributes(params[:user])
                flash[:notice] = 'Account was successfully updated.'
                format.html { redirect_to(@user) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
            end
        end
    end

  
    def deactivate
        @user = User.find(params[:id])
        #        if @user.update_attributes(:active => false)
        if @user.deactivate!
            flash[:notice] = "User deactivated"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head :ok }
            end
        else
            flash[:notice] = "User could not be deactivated"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head "Failed to Destroy" }
            end
        end
    end


    def activate
        @user = User.find(params[:id])
        #        if @user.update_attributes(:active => false)
        if @user.activate!
            flash[:notice] = "User activated"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head :ok }
            end
        else
            flash[:notice] = "User could not be activated"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head "Failed to Destroy" }
            end
        end
    end

    def assignbusinessrole
        @user = User.find(params[:id])
        #        if @user.update_attributes(:active => false)
        if @user.businessrole!
            flash[:notice] = "User role assigned"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head :ok }
            end
        else
            flash[:notice] = "User role could not be changed"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head "500" }
            end
        end
    end

    def assignsiterole
        @user = User.find(params[:id])
        #        if @user.update_attributes(:active => false)
        if @user.siterole!
            flash[:notice] = "User role assigned"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head :ok }
            end
        else
            flash[:notice] = "User role could not be changed"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head "500" }
            end
        end
    end

    def assigncontribrole
        @user = User.find(params[:id])
        #        if @user.update_attributes(:active => false)
        if @user.contribrole!
            flash[:notice] = "User role assigned"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head :ok }
            end
        else
            flash[:notice] = "User role could not be changed"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head "500" }
            end
        end
    end
    # DELETE /users/1
    # DELETE /users/1.xml
    def destroy
        @user = User.find(params[:id])
        # @user.update_attributes(:active => false)
        #        @user.active = params[false]
        #        @user.save
        if @user.destroy
            flash[:notice] = "User destroyed"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head :ok }
            end
        else
            flash[:notice] = "User could not be destroyed"
            respond_to do |format|
                format.html { redirect_to(users_url) }
                format.xml  { head "Failed to Destroy" }
            end
        end
    end
end
