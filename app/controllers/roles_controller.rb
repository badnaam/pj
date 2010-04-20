class RolesController < ApplicationController
    layout "users"
    
    filter_resource_access
    
    def index
        @roles = Role.all
        respond_to do |format|
            format.html #index.html.erb
            format.xml {render :xml => @roles}
        end
    end

    # GET /users/new
    # GET /users/new.xml
    def new
        @role  = Role.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @role }
        end
    end

    def show
        @role = Role.find(params[:id])
        @users = @role.users
    
        respond_to do |format|
            format.html #index.html.erb
            format.xml {render :xml => @role}
        end
    end

    def edit
        @role = Role.find(params[:id])
    end

    #POST /users
    #POST /users.xml
    def create
        @role = Role.new(params[:role])

        respond_to do |format|
            if @role.save
                flash[:notice] = "Role successfully created"
                format.html {redirect_to @role}
                format.xml  {render :xml=> @role, :status=>:created, :location => @role}
            else
                format.html {render :action => "new"}
                format.xml {render :xml => @role.errors, :status => :unprocessable_entry}
            end
        end
    end

    #POST /users
    #POST /users.xml
    def update
        @role = Role.find(params[:id])

        respond_to do |format|
            if @role.update_attributes(params[:role])
                flash[:notice] = "Role successfully updated"
                format.html {redirect_to @role}
                format.xml  {render :xml=> @role, :status=>:created, :location => @role}
            else
                format.html {render :action => "edit"}
                format.xml {render :xml => @role.errors, :status => :unprocessable_entry}
            end
        end
    end

    #DELETE role/1
    #DELETE role/1.xml

    def destroy
        @role = Role.find(params[:id])
        @role.destroy

        respond_to do |format|
            format.html {redirect_to(roles_url)}
            format.xml {head :ok}
        end
    end

end