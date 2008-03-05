class <%= class_name %>Controller < ApplicationController
  no_authentication_for :signin, :signout, :signup

  def signin
    if request.post?
      user_sym = ApplicationController.authentication_options[:model]
      user_class = user_sym.to_class
      signin_id = user_class.acts_as_authenticated_options[:signin_id]
      password = user_class.acts_as_authenticated_options[:password]
      user = user_class.authenticate(params[user_sym][signin_id], user_class.hash_password(params[user_sym][password]))
      if user
        session[user_sym] = user
        if session[:intended_uri]
          redirect_to(session[:intended_uri])
          session[:intended_uri] = nil
        else
          redirect_to :controller => "your_controller"
        end
      else
        flash[:notice] = "We could not log you in."
      end
    end
  end

  def signout
    session[ApplicationController.authentication_options[:model]] = nil
    redirect_to authentication_options[:signin]
  end
  
  def signup
  end
end
