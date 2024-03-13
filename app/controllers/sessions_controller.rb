class SessionsController < ApplicationController
    def new
    end


    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user&.authenticate(params[:session][:password])
            if user.is_activated?
                log_in user
                params[:session][:remember_me] == "1" ? remember(user) : forget(user)
                remember user
                previous_url = session[:previous_url]
                redirect_to previous_url || user
            else
                message = "Account not activated. Please check your email to activate!"
                flash[:warning] = message
                redirect_to root_url
            end
        else
            flash[:danger] = "Invalid email or password"
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        log_out if logged_in?
        redirect_to root_url
    end
end
