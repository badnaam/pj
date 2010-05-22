class HomeController < ApplicationController
    filter_resource_access

    layout "wo_r_nav"
  
    def index
        @user = User.new
        @syms = @user.role_symbols
    end

end
