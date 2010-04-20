class UserSessionsController < ApplicationController
    layout "users"

    def new
        @user_session = UserSession.new
    end

    def create
        @user_session = UserSession.new(params[:user_session])
        if @user_session.save
            flash[:message] = "Login successful"
            redirect_to root_url
        else
            flash[:message] = "Login failed"
            render :action => "new"
        end
    end

    def destroy
        @user_session = UserSession.find

        if @user_session.destroy
            flash[:message] = "Logged out"
            redirect_to root_url
        end
    end
end
