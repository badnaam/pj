class SearchesController < ApplicationController
    layout "users"

    def search_set
        if request.xhr? && params[:filter_search] == "true"
            @filter_search = true
        end
        if params[:refine_open] == "true"
            @refine_open = true
        else
            @refine_open = false
        end
        search_options = Search.process_params(params, @filter_search)
        @search = Search.new(search_options)    
        @results = Search.execute(search_options)
        @searches = @results.for
        set_search_status
        respond_to do |format|
            format.html
            format.js
        end
    end

    private

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
