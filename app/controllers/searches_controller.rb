class SearchesController < ApplicationController
    layout "users"
    before_filter :configure_geo
    
    def search_set
        if request.xhr? && params[:filter_search] == "true"
            @filter_search = true
        end
        if params[:refine_open] == "true"
            @refine_open = true
        else
            @refine_open = false
        end
        if params[:stype] == "1"
            @all_search = true
        else
            @all_search = false
        end
        
        search_options = Search.process_params(params, @filter_search)
        @search = Search.new(search_options)
        @results = Search.execute(search_options)
        @searches = @results.for
        set_search_status
        if request.xhr?
            @map = Variable.new('map')
            @group = Variable.new('search_marker_group')
            @markers = get_markers
        else
            build_index_map
        end
        respond_to do |format|
            format.html
            format.js
        end
    end

    private

    def configure_geo
        if params[:search]
            if !params[:search][:geo].nil?
                cookies[:geo_loc] = params[:search][:geo]
            end
        else
            cookies[:geo_loc] = Search::DEFAULT_LOCATION
        end
    end
    
    def build_index_map
        @map = GMap.new('map_div_id')
        @map.control_init(:small_map => true, :map_type => false)
        @map.center_zoom_init([38.134557,-95.537109],4)
        # to center on usa -  @map.center_zoom_init([38.134557,-95.537109],4)
        @markers = Hash.new

        @searches.each_with_index do |s, index|
            addr = [s.lat, s.lng]
            icon = GCustomIcon.new(:width => 20, :height => 20, :primaryColor => "#006600", :label => "#{index + 1}", :labelColor => "#EEEEEE",
            :shape => "circle", :labelSize => 0)
            marker = GMarker.new(addr,:title => "xxx",
                :info_window => "xxx", :icon => icon)
            @markers[s.class.to_s.concat(s.id.to_s)] = marker
        end
        group = GMarkerGroup.new(true, @markers)
        @map.overlay_global_init(group, 'search_marker_group')
        @map.record_init group.center_and_zoom_on_markers
    end

    def get_markers
        @markers = Hash.new
        i = 0
        @searches.each_with_index do |s, index|
            address = [s.lat, s.lng]
            icon = GCustomIcon.new(:width => 20, :height => 20, :primaryColor => "#006600", :label => "#{index + 1}", :labelColor => "#EEEEEE",
            :shape => "circle", :labelSize => 0)
            @markers[s.class.to_s.concat(s.id.to_s)] = GMarker.new([address[0], address[1]],:title => i.to_s ,
                :info_window => '',  :icon => icon)
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
  
    def set_search_status
        if @searches.nil?
            if @searches.total_entries == 0
                @search_status = "Sorry no matches found."
            end
            @search_status = "Sorry no matches found."
        else
            tot_pages = (@searches.total_pages) == 0 ? 1 : @searches.total_pages
            search_key = (@searches.args.first.nil?) ? "All" : @searches.args
            @search_status = "Found #{@searches.total_entries} results for #{search_key}. Showing page #{@searches.current_page} of #{tot_pages}."
        end
    end
end
