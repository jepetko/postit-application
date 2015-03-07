class UsersController < ApplicationController

  before_action :require_user

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

  private
  def user_params
    params.require(:user).permit(:username, :password, :phone, :time_zone)
  end

end