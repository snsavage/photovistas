module SessionHelpers
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) unless session[:user_id] == nil
  end

  def logged_in?
    !!current_user
  end
end

