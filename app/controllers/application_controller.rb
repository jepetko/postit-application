class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # make it available in views
  helper_method :current_user, :logged_in?

  def current_user
    # if there's authenticated user, return the user obj
    # else return nil
    # ||= dont hit the database if not necessary
    # pattern "memoization"
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = 'Must be logged in to do that.'
      redirect_to root_path
    end
  end

  def login(user)
    session[:user_id] = user.id unless user.nil?
  end

  def require_admin
    access_denied unless logged_in? && current_user.admin?
  end

  def require_edit_role(post)
    access_denied unless logged_in? && current_user.has_edit_role?(post)
  end

  def access_denied
    flash[:error] = "You can't do that"
    redirect_to root_path
  end
end
