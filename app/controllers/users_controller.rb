class UsersController < ApplicationController
  before_action :find_user, :require_log_in!,  only: [:show, :edit, :update, :destroy,
    :followings, :followers]
  before_action :require_log_in!,  only: [:show, :edit, :update, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :check_admin_role, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  
  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Update profile success!"
      redirect_to @user
    else
      flash[:danger] = "Update profile errors"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User has been deleted"
    redirect_to users_url
  end

  def followings
    @title = "Following"
    @users = @user.followings.paginate(page: params[:page])
    render "users/show_follow"
  end

  def followers
    @title = "Follower"
    @users = @user.followers.paginate(page: params[:page])
    render "users/show_follow"
  end
  
  private

  def find_user
    @user ||= User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    unless same_user? @user
      flash[:warning] = "Not have permission to access"
      redirect_to root_url
    end
  end

  def check_admin_role
    redirect_to root_url unless current_user.admin?
  end
end
