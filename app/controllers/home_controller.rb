class HomeController < ApplicationController
    filter_resource_access

    layout "users"
  
    def index
        @user = User.new
        @syms = @user.role_symbols
    end

end
