class ApplicationController < ActionController::Base
  # def authenticate_administrator!
  #   # Logic to authenticate as administrator
  #   redirect_to new_administrator_session_path unless current_administrator
  # end

  # def current_administrator
  #   # Logic to return the currently logged-in administrator
  #   @current_administrator ||= Administrator.find(session[:administrator_id]) if session[:administrator_id]
  # end

  # before_action :authenticate_administrator!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :gender, :default_address, :default_city, :default_country, :default_postcode, :default_state])
  end

  def after_sign_up_path_for(resource)
    flash[:success] = 'Sign up successful. Please log in.'
    new_user_session_path # Or any other path
  end


  helper_method :current_cart

  private

  def current_cart
    if session[:cart_id]
      Cart.find(session[:cart_id])
    elsif user_signed_in?
      current_user.cart || current_user.create_cart
    else
      Cart.new
    end
  end

end
