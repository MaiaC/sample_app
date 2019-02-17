class UsersController < ApplicationController
  before_action :logged_out, only: [:new, :create]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.where.not(activated: false, id: current_user.id).paginate(page: params[:page], per_page: 10)
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated == true
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_path
    else
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "You have successfully updated your account!"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to(users_path)
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    #before filters

    def logged_out
      if logged_in?
        flash[:danger] = "You must be logged out to create new user."
        redirect_to current_user
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless @user == current_user
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
