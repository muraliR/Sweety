class ApplicationController < ActionController::Base

  include Tool #include Tool Module for Helper Methods
	before_action :configure_devise_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

   protected

  	def configure_devise_permitted_parameters

  		#Allowing Custom Params from Registration Form Inputs
    	registration_params = [:name,:user_type, :email, :password, :password_confirmation]

    	devise_parameter_sanitizer.for(:sign_up) { 
    		|u| u.permit(registration_params) 
  		}

  	end

end
