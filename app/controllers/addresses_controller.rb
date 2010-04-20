class AddressesController < ApplicationController
    def index
        @addressible = find_addressible
        @addresses = @addressible.all
    end
  
    def show
        @address = Address.find(params[:id])
    end
  
    def new
        @address = Address.new
    end
  
    def create
        @addressible = find_addressible
        @address = @addressible.addresses.build(params[:address]) 
        if @address.save
            flash[:notice] = "Successfully created address."
            redirect_to @address
        else
            render :action => 'new'
        end
    end
  
    def edit
        @address = Address.find(params[:id])
    end
  
    def update
        @address = Address.find(params[:id])
        if @address.update_attributes(params[:address])
            flash[:notice] = "Successfully updated address."
            redirect_to @address
        else
            render :action => 'edit'
        end
    end
  
    def destroy
        @address = Address.find(params[:id])
        @address.destroy
        flash[:notice] = "Successfully destroyed address."
        redirect_to addresses_url
    end

    def find_addressible
        params.each do |name, value|
            if name =~ /(.+)_id$/
                return $1.classify.constantize.find(value)
            end
        end
        nil
    end
end
