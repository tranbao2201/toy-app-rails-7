class ResetPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:password_reset][:email])
    if user
      user.create_reset_digest
      user.send_password_reset_email
      flash[:success] = "We have send you an email to reset password. Please check it out!!!"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found!!!"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
    expired_time_valid?(@user)
    unless @user || @user.authenticated?(:reset, params[:token])
      flash[:danger] = "Invalid token reset"
      redirect_to root_url
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(reset_params)
      flash[:danger] = "Reset password success!!!"
      redirect_to new_session_url
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def expired_time_valid? user
    if user.reset_is_expired?
      flash[:danger] = "Token is expired!!!"
      redirect_to new_session_url
    end
  end
end
