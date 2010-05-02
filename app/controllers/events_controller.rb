class EventsController < ApplicationController
    layout "events"

    before_filter :init_search, :only => [:index]
    
    filter_resource_access
    
    def index

        if @all
            #            ignore every othe filter besides results per page
            @events = Event.all.paginate(:page => params[:page], :per_page => @per_page, :include => :address, :order => "event_date DESC")
        else
            @events = Event.searchlogic(@searchparams).paginate(:page => params[:page], :per_page => @per_page, :include => :address, :order => @sort_by)
        end
        
        unless request.xhr?
            build_index_map@events
        else
            @map = Variable.new("map")
            @group = Variable.new("event_marker_group")
            @markers = get_markers(@events)
        end
        
        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @events }
            format.js 
        end
    end

   
    def show
        @event = Event.find(params[:id])

        respond_to do |format|
            format.js
            format.html # show.html.erb
            format.xml  { render :xml => @event }
        end
    end

    def new
        @event = Event.new
        address = @event.build_address
        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @event }
        end
    end

    def edit
        @event = Event.find(params[:id])
       
    end

    def create
        @event = Event.new(params[:event])
        @event.user_id = current_user.id;
        respond_to do |format|
            if @event.save
#                @event.update_categorizations
                flash[:notice] = 'Event was successfully created.'
                format.html { redirect_to(@event) }
                format.xml  { render :xml => @event, :status => :created, :location => @event }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update
        @event = Event.find(params[:id])

        respond_to do |format|
            if @event.update_attributes(params[:event])
                flash[:notice] = 'Event was successfully updated.'
                format.html { redirect_to(@event) }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        @event = Event.find(params[:id])
        @event.destroy

        respond_to do |format|
            format.html { redirect_to(events_url) }
            format.xml  { head :ok }
        end
    end

    def init_search
        #for default index load or for all
        @per_page = params[:slt_per_page]
        @per_page ||= session[:per_page]
        @per_page ||= '10'
        session[:per_page] = @per_page

        @sort_by = params[:slt_sort_by]
        @sort_by ||= session[:events_sort_by]
        @sort_by ||= 'event_date DESC'
        session[:event_sort_by] = @sort_by


        unless params[:all]
            @searchparams = Hash.new

            @searchparams[:title_like] ||= params[:title_like]
            @searchparams[:title_like] ||= ""

            @searchparams[:categorizations_category_id_like_any] ||= params[:category_ids]
#            @searchparams[:categorizations_category_id_like_any] ||= session[:category_ids]
#            @searchparams[:categorizations_category_id_like_any] ||= []
#            session[:category_ids] = @searchparams[:categorizations_category_id_like_any]
#
            
            @th_type ||= params[:th_type]
            @th_type ||= session[:th_type] #unless session[:th_type].blank?
            @th_type ||= "thisweek"
            session[:th_type] = @th_type
            
            case @th_type
            when "today"
                @searchparams[:event_date_equals] = Date.today
            when "tomorrow"
                @searchparams[:event_date_equals] = Date.tomorrow
            when "thisweek"
                @searchparams[:event_date_equals] = (Date.today..Date.today.end_of_week)
            when "weekend"
                @searchparams[:event_date_equals] = (Date.today.end_of_week..Date.today.end_of_week - 2)
            when "nextweek"
                @searchparams[:event_date_equals] = (Date.today..Date.today.next_week + 7)
            when "cdate"
                @searchparams[:event_date_equals] = params[:event_date_equals]
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
            session[:th_type] = ''
            session[:category_ids] = ''
        end

    end
    
    def build_index_map(events)
        @map = GMap.new("map_div_id")
        @map.control_init(:small_map => true, :map_type => false)
        @map.center_zoom_init([38.134557,-95.537109],4)
        # to center on usa -  @map.center_zoom_init([38.134557,-95.537109],4)
        @markers = Hash.new
        
        events.each do |event|
            addr = event.get_lat_lng
            marker = GMarker.new(addr,:title => event.title,
                :info_window => event.description)
            @markers[event.id] = marker
        end
        group = GMarkerGroup.new(true, @markers)
        @map.overlay_global_init(group, "event_marker_group")
        @map.record_init group.center_and_zoom_on_markers
    end

    def get_markers(events)
        @markers = Hash.new
        i = 0
        events.each do |event|
            address = event.get_lat_lng
            @markers[event.id] = GMarker.new([address[0], address[1]],:title => i.to_s ,
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
