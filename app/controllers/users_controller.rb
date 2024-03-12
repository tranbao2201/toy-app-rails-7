class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      log_in @user
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Update profile success!"
      redirect_to edit_user_path(@user)
    else
      flash[:danger] = "Update profile errors"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user ||= User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
