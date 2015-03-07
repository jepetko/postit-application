class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # make it available in views
  helper_method :current_user, :logged_in?, :is_path_user_posts?, :is_path_user_comments?, :activate_if

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
    return if user.nil?
    session[:user_id] = user.id
  end

  def is_path_user_posts?(user)
    request.fullpath == user_path(user)
  end

  def is_path_user_comments?(user)
    request.fullpath == user_path(user, tab: :comments)
  end

  def activate_if(path)
    return ' class="active"'.html_safe if request.fullpath == path
    ''
  end
end
