module SessionsHelper
    def log_in user
        session[:user_id] = user.id
    end
    def current_user
        @user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?
        current_user.present?
    end

    def log_out
        session[:user_id] = nil
        redirect_to root_url
    end
end
