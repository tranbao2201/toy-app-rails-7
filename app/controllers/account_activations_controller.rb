class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        if user.authenticated?(:activation, params[:token])
            flash[:success] = "Account is activated!!!"
            user.activate_account
            log_in user
            redirect_to user
        else
        end
    end
end
