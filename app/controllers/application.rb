# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_wifidog.rb_session_id'

  @@last_garbage_collection ||= nil

  def requires_admin
    return true if is_logged_in? and is_admin?
    flash.now[:notice] = 'Access denied.'
    redirect_to :controller => 'user', :action => 'login_profile'
    false
  end

  def is_logged_in?
    !session[:user].nil? && session[:user].user_role != User::ROLE_SPLASH
  end

  def is_admin?
    session[:user][:user_role] == User::ROLE_ADMIN
  end

  def garbage_collect
    if !@@last_garbage_collection or Time.now - @@last_garbage_collection >= 5.minutes
      logger.info "Garbage collection"
      @@last_garbage_collection = Time.now

      delete_unused_connections
      expire_old_connections
    end
  end

private
  def delete_unused_connections
    five_minutes_ago = Time.now - 5.minutes
    for connection in Connection.find(:all, :conditions => ["used_on is null and created_on < ?", five_minutes_ago])
      connection.destroy
    end
  end

  def expire_old_connections
    five_minutes_ago = Time.now - 5.minutes
    for connection in Connection.find(:all, :conditions => ["used_on is not null and expires_on is null and updated_on < ?", five_minutes_ago])
      connection.update_attribute("expires_on", Time.now)
    end
  end

end
