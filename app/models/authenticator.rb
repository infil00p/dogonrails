require 'uuidtools'
require 'radius/auth'

class Authenticator < ActiveRecord::Base

  # This is to clean up the User Controller, so that we can create an Authenticator class that stores
  # all the authentication information and sends it to an external auth server
  
  class << self
    
    def list(page)
        paginate :per_page => 20, :page => page 
    end   
    
  end
  
  def authenticate(username, password)
    case auth_type
      when "local":
        authenticate_plain(username, password)
      when "radius":
        authenticate_radius(username, password)
      when "splash"
        authenticate_splash
    end
  end

  def authenticate_plain(username, password)
      User.authenticate(username, password)
  end
  
  def authenticate_radius(username, password)
    auth = Radius::Auth.new(dictionary_path, auth_host, auth_timeout)
    if (auth.check_passwd(username, password, auth_secret))
       radius_username = username + "raduser"
       user.save!
    els
      return nil
    end
  end
  
  def authenticate_splash
      random_string = UUID.random_create.to_s
      user = User.create!(
            :login => random_string,
            :password => random_string,
            :password_confirmation => random_string,
            :email => random_string + "@dogonrails.org",
            :activated => true,
            :private => true
            )
       user.save!
  end
  
end
