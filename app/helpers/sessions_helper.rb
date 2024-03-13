module SessionsHelper
    def log_in user
        session[:user_id] = user.id
        session[:session_token] = user.session_token
    end
    def current_user
        return @current_user  if @current_user.present?

        if(user_id = session[:user_id])
            user = User.find_by(id: user_id)
            if user && session[:session_token] = user.session_token
                @current_user = user
            end
        elsif(user_id = cookies.encrypted[:user_id])
           user = User.find_by(id: user_id)
           if user&.authenticated?(:remember, cookies[:remember_token])
            log_in(user)
            @current_user = user
           end
        end
    end

    def logged_in?
        current_user.present?
    end

    def log_out
        reset_session
        forget(current_user)
        @current_user = nil
    end

    def remember user
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def forget user
        user.forget
        cookies.delete(:remember_token)
        cookies.delete(:user_id)
    end

    def same_user?(user)
        current_user.id == user.id
    end

    def store_location
        session[:previous_url] = request.original_url if request.get?
    end
end
