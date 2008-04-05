class PortalController < ApplicationController

  def index
    # No gw_id in url? Get it from the session if it exists
    if !params[:gw_id] and session[:access_node] and session[:access_node].mac
      params[:gw_id] = session[:access_node].mac
    end

    @node = AccessNode.find_by_mac(params[:gw_id])
    if !@node
      redirect_to :action => "external" and return
    end

    if @node.redirect_url.blank?
      redirect_to session[:forward_url] and return
    else
      redirect_to @node.redirect_url and return
    end
  end

  def external
  end
end
