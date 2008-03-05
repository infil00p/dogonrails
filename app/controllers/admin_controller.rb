class AdminController < ApplicationController
  before_filter :requires_admin

  def index

  end

  def users
    page = params[:page]
    if page.nil?
      page = 1
    end
    @users = User.list(page)
  end
  
  def auth
    page = params[:page]
    if page.nil?
      page = 1
    end
    @auth = Authenticator.list(page)
  end
  
  def create_auth_method
    return unless request.post?
    @auth = Authenticator.new(params[:auth])
    @auth.save
  end
  
  def update_auth_method
    @auth = Authenticator.find(params[:uid])
    return unless request.post?    
    @auth.attributes = params[:auth]
    @auth.save
  end
  
  def delete_auth_method
    @auth = Authenticator.find(params[:uid])
    @auth.destroy
    redirect_to :back
  end
  
  def edit_user
    @user = User.find(params[:uid])
    return unless request.post?    
    @user.attributes = params[:user]  
    @user.save
  end

  def nodes
    @access_nodes = AccessNode.find(:all)
  end
  
  # This gets global settings for the network, and this will have default
  # settings when the site is installed
  
  def globals
    config = Globalconf.find(:all)
    if config.length == 0
      @global = Globalconf.new
    else
      @global = config.first
    end
    return unless request.post?
    @global.network_name = params[:globalconf]['network_name']
    @global.center_lat = params[:globalconf]['center_lat']
    @global.center_lng = params[:globalconf]['center_lng']
    @global.ganal = params[:globalconf]['ganal']
    @global.zoom = params[:globalconf]['zoom']
    @global.gmaps_key = params[:globalconf]['gmaps_key']
    unless params['network_logo'] == ''
      @global.logo = params['network_logo']
    end
    @global.save!
  end

  def delete_user
    user = User.find(params[:uid])
    user.destroy
  end


end
