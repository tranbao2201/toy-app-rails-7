class SessionsController < ApplicationController
    def new
    end


    def create
        user = User.find_by(email: params[:session][:email])
        if user&.authenticate(params[:session][:password])
            log_in user
            redirect_to user
        else
            flash[:danger] = "Invalid email or password"
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        log_out if logged_in?
    end
end
