# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
    #    layout "users"
    
    #    layout proc{ |c| c.request.xhr? ? false : "users" }

    helper :all # include all helpers, all the time
    protect_from_forgery # See ActionController::RequestForgeryProtection for details
    helper_method :current_user, :current_role, :is_admin?, :is_business?, :init_search
    #    before_filter { |c| Authorization.current_user = c.current_user }
    geocode_ip_address

    before_filter :set_current_user

    def geokit
        @location = session[:geo_location]  # @location is a GeoLoc instance.
    end
    
#    def init_search(type)
#        if session[:esearch]
#            session[:esearch][:stype] = type
#            @search = Search.new(session[:esearch])
#        else
#            @search = Search.new(Hash.new)
#        end
#    end
    
    def call_rake(task, options = {})
        options[:rails_env] = Rails.env
        args = options.map{ |n, v| "#{n.to_s.upcase}='#{v}'" }
        #System dependent - consider changing
        system "/usr/bin/rake #{task} #{args.join(' ')} >> #{Rails.root}/log/rake.log &"
    end

    def permission_denied
        flash[:notice] = "Sorry, permission denied."
        #        if request.env["HTTP_REFERER"].nil? then
        #            redirect_to root_url
        #        else
        #            redirect_to request.env["HTTP_REFERER"]
        #        end
        #

        respond_to do |format|
            format.html { redirect_to(:back) rescue redirect_to('/') }
            format.xml  { head :unauthorized }
            format.js   { head :unauthorized }
        end
    end 
    
    #    Protected methods
    protected

    def set_current_user
        Authorization.current_user = current_user
    end

    #  Private methods
    private

    def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
    end

    def current_user
        @current_user = current_user_session && current_user_session.record
    end

    def current_role
        unless current_user.nil?
            unless current_user.role.blank?
                current_user.role.name
            end
        end
    end

    def is_admin?
        if current_role == 'admin'
            return true
        end
    end

    def is_business?
        if current_role == 'business'
            return true
        end
    end
    
    def require_user
        unless current_user
            store_location
            flash[:notice] = "You must be logged in to access this page"
            redirect_to new_user_session_url
            return false
        end
    end

    def require_no_user
        if current_user
            store_location
            flash[:notice] = "You must be logged out to access this page"
            redirect_to account_url
            return false
        end
    end

    def store_location
        session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
    end

    # Scrub sensitive parameters from your log
    #filter_parameter_logging :password
end
