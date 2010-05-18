class MerchantsController < ApplicationController
    # GET /merchants
    # GET /merchants.xml
    layout "users"
    before_filter :init_search, :only => [:index]
    filter_resource_access
    
    def index

        if @all
            #            ignore every othe filter besides results per page
            @merchants = Merchant.all.paginate(:page => params[:page], :per_page => @per_page, :include => :address, :order => "green_grade DESC")
        else
            @merchants = Merchant.searchlogic(@searchparams).paginate(:page => params[:page], :per_page => @per_page, :include => :address, :order => @sort_by)
        end

        unless request.xhr?
            build_index_map@merchants
        else
            @map = Variable.new("map")
            @group = Variable.new("merchant_marker_group")
            @markers = get_markers(@merchants)
        end

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
        @merchant = Merchant.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @merchant }
        end
    end

    # GET /merchants/new
    # GET /merchants/new.xml
    def new
        @merchant = Merchant.new
        @address = @merchant.build_address
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
        @merchant = Merchant.new(params[:merchant])
        @merchant.owner_id = current_user.id
        
        respond_to do |format|
            if @merchant.save
                flash[:notice] = 'Merchant was successfully created.'
                format.html { redirect_to(@merchant) }
                format.xml  { render :xml => @merchant, :status => :created, :location => @merchant }
            else
                format.html { render :action => "new" }
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
                format.html { render :action => "edit" }
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

    def init_search
        #Find the association in case it's a Merchant or Category based listing
        association_name = find_association_name
        unless association_name.kind_of?(HashWithIndifferentAccess)
            case association_name
            when "category"
                @category_merchant_listing = true
            end
        end

        #for default index load or for all
        @per_page = params[:slt_per_page]
        @per_page ||= session[:per_page]
        @per_page ||= '10'
        session[:per_page] = @per_page

        @sort_by = params[:slt_sort_by]
        @sort_by ||= session[:events_sort_by]
        @sort_by ||= 'green_grade DESC'
        session[:event_sort_by] = @sort_by


        unless params[:all]
            @searchparams = Hash.new

            @searchparams[:name_like] ||= params[:name_like]
            @searchparams[:name_like] ||= ""

            if @category_merchant_listing == true
                #                @searchparams[:merchant_categorizations_merchant_category_id_like_any] ||= params[:merchant_category_id]
                @searchparams[:merchant_category_id_like_any] ||= params[:merchant_category_id]
            else
                #                @searchparams[:merchant_categorizations_merchant_category_id_like_any] ||= params[:merchant_category_ids]
                @searchparams[:merchant_category_id_like_any] ||= params[:merchant_category_ids]
            end

            @searchparams[:origin] = params[:txtOrigin]
            @searchparams[:origin] ||= session[:origin] unless session[:origin].blank?
            @searchparams[:origin] ||= '94131'
            session[:origin] = @searchparams[:origin]

            @searchparams[:within]  = params[:sltDistance]
            @searchparams[:within] ||= session[:distance] unless  session[:distance].blank?
            @searchparams[:within] ||= '15'
            session[:distance] = @searchparams[:within]

        else
            @all = true
            session[:distance] = ''
            session[:origin] = ''
            session[:category_ids] = ''
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

    def build_index_map(merchants)
        @map = GMap.new("map_div_id")
        @map.control_init(:small_map => true, :map_type => false)
        @map.center_zoom_init([38.134557,-95.537109],4)
        # to center on usa -  @map.center_zoom_init([38.134557,-95.537109],4)
        @markers = Hash.new

        merchants.each do |merchant|
            addr = merchant.get_lat_lng
            marker = GMarker.new(addr,:title => merchant.name,
                :info_window => merchant.description)
            @markers[merchant.id] = marker
        end
        group = GMarkerGroup.new(true, @markers)
        @map.overlay_global_init(group, "merchant_marker_group")
        @map.record_init group.center_and_zoom_on_markers
    end

    def get_markers(merchants)
        @markers = Hash.new
        i = 0
        merchants.each do |merchant|
            address = merchant.get_lat_lng
            @markers[merchant.id] = GMarker.new([address[0], address[1]],:title => i.to_s ,
                :info_window => "")
        end
        return @markers
    end

    def bounding_box_center(markers)
        maxlat, maxlng, minlat, minlng = -Float::MAX, -Float::MAX, Float::MAX, Float::MAX
        markers.each do |marker|
            coord = marker.point
            maxlat = coord.lat if coord.lat > maxlat
            minlat = coord.lat if coord.lat < minlat
            maxlng = coord.lng if coord.lng > maxlng
            minlng = coord.lng if coord.lng < minlng
        end
        return [(maxlat + minlat)/2,(maxlng + minlng)/2]
    end
  
end
