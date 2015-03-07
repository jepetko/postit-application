class SessionsController < ApplicationController

  def new

  end

  def create
    # 1. get the user obj
    # 2. see if password matches
    # 3. if so, log in
    # 4. if not, error message
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'You are logged in!'
      redirect_to root_path
    else
      flash[:error] = 'User credentials invalid.'
      # why not render :new
      redirect_to register_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out!"
    redirect_to root_path
  end
end