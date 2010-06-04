class SearchesController < ApplicationController
    # GET /searches
    # GET /searches.xml
    layout "users", :only => [:search_show]
    
    # GET /searches/1
    # GET /searches/1.xml
    def search_show
        if current_user
            @s = Search.user_id_equals(current_user.id).stype_equals(params[:stype])
            unless @s.blank?
                @search = @s.first
            end
        elsif session[:gsearch]
            @search = Search.new(session[:gsearch])
        else
            @search = Search.new
        end
        var = get_var(@search)
        @result_class = params[:refine][:class] if params[:refine]
        @results = Search.execute(@search[:keywords], var)
        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @search }
        end
    end

    def search_set
        if current_user
            @s = Search.user_id_equals(current_user.id).stype_equals(params[:stype])
            unless @s.blank?
                @search = @s.first
                @search.update_attributes(params[:search])
            else
                params[:search][:stype] = params[:stype]
                @search = current_user.searches.build(params[:search])
                @search.save
            end
        else
            session[:gsearch] = params[:search]
            @search = Search.new(params[:search])
        end
        
        respond_to do |format|
            format.html { redirect_to :controller => :searches, :action => :search_show, :stype => params[:stype] }
            format.xml  { head :ok }
        end
    end

    def get_var(search)
        var = Hash.new
        var[:order] = search[:order]
        var[:geo] = search[:geo]
        var[:within] = search[:within]
        if params[:refine]
            var[:refine] = params[:refine]
        end
        return var
    end
end
