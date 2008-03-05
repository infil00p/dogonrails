class AccessNodesController < ApplicationController

  # There should be no way to create a node
  before_filter :is_logged_in?, :only => ['new', 'create', 'edit', 'update']

  def index
    googlemaps
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :update ],
         :redirect_to => { :action => :list }

  def list
    user = session[:user]
    @access_nodes = user.access_nodes
  end
  
  def find_mac
    page = params[:page] || 1
  end
  
  def googlemaps
    @access_nodes = AccessNode.find(:all)
    @routes = []
    @access_nodes.each do | node |
      unless node.batman_node.nil? || node.batman_node.gateway?
        route_list = node.batman_node.routes
        ip_addrs = route_list.split(',')
        route = [node]
        ip_addrs.each do |ip_addr|
          batman_node = BatmanNode.find_by_last_ip(ip_addr)
          unless batman_node.nil?
            route << batman_node.access_node
          end
        end
        @routes << route
      end
    end
    render(:action => 'googlemaps')
  end        
  
  def googleearth
    @access_nodes = AccessNode.find(:all)
    @response.headers["Content-Type"] = 'application/keyhole'
    render(:action => 'googleearth', :layout => 'googleearth')
  end
  
  def merhaki
    @access_nodes = AccessNode.find(:all)
    @connections = Connection.find(:all)
    render(:action => "merhaki", :layout => "merhaki")
  end
  
  def new
    @access_node = AccessNode.new
  end

  def show
    page = params[:page] || 1
    timeframe = params[:time] || Time.now - 1.month
    @access_node = AccessNode.find(params[:id])    
    @connections = Connection.list_by_date(page, timeframe, @access_node)
    @access_node.bandwidth_graph(timeframe)
    @access_node.usage_graph(timeframe)
  end

  def create
    @access_node = AccessNode.new(params[:access_node])
    @user = session[:user]
    if @access_node.save
      @user.access_nodes << @access_node
      @user.save
      flash[:notice] = 'AccessNode was successfully created.'
      redirect_to :action => 'list'
    else
      flash[:error] = "An error occured, unable to create the node"
      render :action => 'new'
    end
  end

  def edit
    @access_node = AccessNode.find(params[:id])    
    if @access_node.owner != session[:user] || session[:user].user_role != 'admin'
      flash[:error] = 'This node is not yours!'
      return redirect_to :back
    end
  end

  def update
    @access_node = AccessNode.find(params[:id])
    if @access_node.owner != session[:user] || session[:user].user_role != 'admin'
      flash[:error] = 'This node is not yours!'
      return redirect_to :back
    end
    if @access_node.update_attributes(params[:access_node])
      flash[:notice] = 'AccessNode was successfully updated.'
      redirect_to :action => 'show', :id => @access_node
    else
      render :action => 'edit'
    end
  end
  
  # Interface for Python Heartbeat Code
  # Designed for Wifi + GPS Use Case
  
  def moving
    @access_node = AccessNode.find(params[:node_id])
    @access_node.ele = params[:ele]
    @access_node.lat = params[:lat]
    @access_node.lng = params[:lng]
    @access_node.save!
  end
  
  def blacklist
    blacklisted = BannedMac.new
    blacklisted.mac = params[:mac]
    blacklisted.date = Time.now
    
    # This breaks the connection
    
    black_conn = Connection.find_by_mac(params[:mac])
    unless black_conn.nil? 
      black_conn.expire!
    end
    
    if blacklisted.save
      flash[:notice] = blacklisted.mac + " has been blacklisted"
    else
      flash[:error] = 'Unable to blacklist ' + blacklisted.mac
    end
    redirect_back
  end
  
end
