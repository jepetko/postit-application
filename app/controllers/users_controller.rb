class UsersController < ApplicationController

  before_action :require_user, except: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'Your are registered.'
      login @user
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = 'Your profile has been changed.'
      login @user
      redirect_to root_path
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :phone, :time_zone)
  end

end