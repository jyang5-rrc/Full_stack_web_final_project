class ApplicationController < ActionController::Base
  # def authenticate_administrator!
  #   # Logic to authenticate as administrator
  #   redirect_to new_administrator_session_path unless current_administrator
  # end

  # def current_administrator
  #   # Logic to return the currently logged-in administrator
  #   @current_administrator ||= Administrator.find(session[:administrator_id]) if session[:administrator_id]
  # end

  before_action :authenticate_administrator!

end
