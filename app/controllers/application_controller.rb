class ApplicationController < ActionController::Base
    include SessionsHelper
    
    def require_log_in!
        unless logged_in?
          store_location
          flash[:warning] = "Please loggin"
          redirect_to new_session_url
        end
    end
end
