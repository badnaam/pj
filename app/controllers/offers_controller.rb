class OffersController < ApplicationController
    # GET /offers
    # GET /offers.xml
    layout "users"
    before_filter :init_offerable
    
    def index
        @offers = Offer.offerable_type_equals(@offerable_name).offerable_id_equals(@offerable_id)

        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @offers }
        end
    end

    # GET /offers/1
    # GET /offers/1.xml
    def show
        @offer = @offerable.offers.find_by_id(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @offer }
        end
    end

    # GET /offers/new
    # GET /offers/new.xml
    def new
        @offer = @offerable.offers.build

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @offer }
        end
    end

    # GET /offers/1/edit
    def edit
        @offer = @offerable.offers.find_by_id(params[:id])
    end

    # POST /offers
    # POST /offers.xml
    def create
        @offer = @offerable.offers.build(params[:offer])

        respond_to do |format|
            if @offer.save
                flash[:notice] = 'Offer was successfully created.'
                format.html { redirect_to(polymorphic_path([@offerable, :offers]))}
                format.xml  { render :xml => @offer, :status => :created, :location => @offer }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @offer.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /offers/1
    # PUT /offers/1.xml
    def update
        @offer = @offerable.offers.find_by_id(params[:id])
        params[:offer][:offerable_id] = @offerable_id
        respond_to do |format|
            if @offer.update_attributes(params[:offer])
                flash[:notice] = 'Offer was successfully updated.'
#                format.html { redirect_to(:action => :index, "#{@offerable_name}_id" => @offerable_id)}
                format.html { redirect_to(polymorphic_path([@offerable, :offers]))}
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @offer.errors, :status => :unprocessable_entity }
            end
        end
    end

    # DELETE /offers/1
    # DELETE /offers/1.xml
    def destroy
        @offer = @offerable.offers.find_by_id(params[:id])
        @offer.destroy

        respond_to do |format|
            format.html { redirect_to(polymorphic_path([@offerable, :offers]))}
            format.xml { head :ok }
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


    private
    
    def  init_offerable
        if (params[:action] == "update" || params[:action] == "create")
            @offerable_name = params[:offer][:offerable_type]
        else
            @offerable_name = find_association_name
        end

        @offerable_id = params[:offer][:offerable_id] if !params[:offer].nil?
        @offerable_id ||= params["#{@offerable_name}_id"]
        @offerable = @offerable_name.classify.constantize.find(@offerable_id)
    end
end
