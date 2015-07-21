class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize
  protect_from_forgery with: :exception
  include SessionsHelper
  
    

    
  protected
  
    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end    
    
    def check_if_admin
      unless User.find_by(id: session[:user_id]).admin?
        #notice: "You are not authorized"
        redirect_to transactions_url 
      end
    end

  #def logged_in?
  #  session[:user_id]
  #end
      
    
end
