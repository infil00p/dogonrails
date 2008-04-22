class GlobalsController < ApplicationController

  before_filter :requires_admin

  def index
    @globals = Globalconf.find(:all)
  end

  def new
    @global = Globalconf.new
  end

  def create
          @global = Globalconf.create params[:globalconf]
          flash[:notice] = "Added settings to the global configuration"
          redirect_to :controller => 'user', :action => 'profile'
  end

  def edit
          @global = Globalconf.find(params[:id])
  end

  def update
          @global = Globalconf.find(params[:id])
          @global.update_attribute(params[:globalconf])
          @global.save
          flash[:notice] = "Updated global configuration settings"
          redirect_to :controller => 'user', :action => 'profile'
  end

  def delete
          @global.destroy
          flash[:notice] = "Deleted a Global Configuration"
          redirect_to :back
  end

end
