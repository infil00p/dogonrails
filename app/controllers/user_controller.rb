require 'uuidtools'

class UserController < ApplicationController
  before_filter :is_logged_in?, :only => ['update']

  def index
    profile
    if is_logged_in?
    	render :action => "profile"
    end
  end
  
  # Edit an avatar icon, password, and public/private setting
  def update
    @user = session[:user]
    return unless request.post?    
    @user.attributes = params[:user]
    @user.save   
  end
  
  def profile    
    @user = User.find_by_login(params[:username]) || session[:user]
    if @user.nil? || (@user != session[:user] && @user.private? == true)
	logger.info('redirecting to front page')
        redirect_to :controller=> 'access_nodes', :action => 'googlemaps' and return    
    end
    @nodes = @user.access_nodes
    @routes = []
    @online_users = 0
    @total_connections = 0
    total_upstream = 0
    total_downstream = 0
    @nodes.each do | node |
      @online_users += node.online_users.length
      @total_connections += node.connections.length
      node.connections.each do |conn|
        total_upstream += conn.outgoing_bytes
        total_downstream += conn.incoming_bytes
      end
    end
    @total_upstream = convert_to_human(total_upstream)
    @total_downstream = convert_to_human(total_downstream)
  end

  def login
    if params[:gw_id] and params[:gw_address] and params[:gw_port]
      # Put in session for later redirect
      session[:gw_id] = params[:gw_id]
      session[:gw_address] = params[:gw_address]
      session[:gw_port] = params[:gw_port]
      session[:forward_url] = params[:url]
      @node = AccessNode.find_by_mac(params[:gw_id])
      
      if @node.nil?
        redirect_to :action => "login_external" and return
      end

      @notices = Notice.find(:all, :conditions => ['date_posted < ? AND expiry_date >= ? AND (access_node_id = ? OR access_node_id is ?)', Time.now, Time.now, @node.id, nil])

      user_agent = request.user_agent.downcase
      mobile = false
      
      # Mobile Request URI
      [ 'iphone' , 'ipod' ].each { |b|
         mobile = true if user_agent.include? b
      }
      
      case @node.auth_mode
        when AccessNode::AuthModes[:normal]:
          if mobile
            render :partial => "login_iphone", :layout => "layouts/mobile.rhtml"
          else
            render :action => "login"
          end
        when AccessNode::AuthModes[:splash]:
          if mobile
            render :partial => "splash_iphone"
          else
            render :action => "splash"
          end
      end
    else
      redirect_to :action => "login_external" and return if !@node
    end
  end
  
  def login_external
    @node = AccessNode.find_by_remote_addr(request.remote_addr)
  end
  
  def login_profile
    return unless request.post?
     if !user = User.authenticate(params[:username], params[:password])
       flash[:notice] = "Username or password invalid"
       redirect_to :back and return          
     end
     # Unlike onsite stuff, we just put the user in the user login
     session[:user] = user
     redirect_to :action => "profile"
  end


  def authenticate
    return unless request.post?      
    redirect_to :controller => "portal" and return if !params[:gw_id]

    node = AccessNode.find_by_mac(params[:gw_id])
    user = nil

    case node.auth_mode
      when AccessNode::AuthModes[:splash]:
        # Create a dummy user to hold statistics and such
        # This user is not publicly visible
        random_string = UUID.random_create.to_s
        user = User.create!(
            :login => random_string,
            :password => random_string,
            :password_confirmation => random_string,
            :email => random_string + "@dogonrails.org",
            :activated => true,
            :private => true,
            :user_role => "splash"
            )
       when AccessNode::AuthModes[:normal]:
	# Normal means that this is the authenticator
        if !user = node.authenticator.authenticate(params[:username], params[:password])
          flash[:notice] = "Username or password invalid"
          redirect_to :back and return
        end
    end

    # Find all user's connections and expire them
    user.expire_all_connections

    # Put user in session variable (used later for finding role, etc.)
    session[:user] = user

    # Put access node in session variable (used later for finding back node)
    session[:access_node] = node

    # Issue a UUID, this is unique and should work with the protocol
    token = UUID.random_create.to_s
    login_connection = Connection.create!(
          :remote_addr => request.remote_addr,
          :token => token,
          :access_node => node,
          :user => user,
	  :forward_url => session[:forward_url]
    )
    
    # Add the timeout to the Connection
    if user.activated.nil?
      # You have 30 minutes to get the e-mail then GTFO!
      login_connection.expires_on = Time.now + 30.minutes
    elsif !node.time_limit.nil? && node.time_limit > 0
      login_connection.expires_on = Time.now + node.time_limit.minutes
    end
    
    redirect_to 'http://' + params[:gw_address].to_s + ':' + params[:gw_port].to_s + '/wifidog/auth?token=' + login_connection.token
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.activation_code = UUID.random_create.to_s
    @user.save!
    SystemMailer.deliver_auth_delivery(@user, url_for(:controller => "user", :action => 'activate', :code => @user.activation_code))
    flash[:notice] = "An email to validate that you're the owner of the submitted email address has been sent to #{@user.email}."    

    if session[:gw_id] and session[:gw_address] and session[:gw_port]
      # Fake user login, works quite well
      params[:username] = params[:user][:login]
      params[:password] = params[:user][:password]
      params[:gw_id] = session[:gw_id]
      params[:gw_address] = session[:gw_address]
      params[:gw_port] = session[:gw_port]
      session[:gw_id] = session[:gw_address] = session[:gw_port] = nil
      authenticate
    else
      # Redirect to user login, we don't have the info to auto-login in the session
      render :action => 'login_profile'
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def activate
    if user = User.find(:first, :conditions => ["activation_code = ? and activated != true", params[:code]])
      user.activate!
      flash[:notice] = "Your account has been activated!"
    else
      flash[:notice] = "This activation code could not be found, or has already been used"
    end
  end
 
  def signup_and_add
	@user = User.new(params[:user])
	@access_node = AccessNode.new(params[:access_node])
	return unless request.post?
	@user.activation_code = UUID.random_create.to_s
	@user.save!
	@access_node.save!
	SystemMailer.deliver_auth_deliver(@user, url_for(:controller => "user", :action => 'activate', :code => @user.activation_code))
	flash[:notice] = "An email to validate that you're the owner of the node has been sent to #{@user.email}."
	render :action => 'login'
  rescue ActiveRecord::RecordInvalid
	  render :action => 'signup'
  end 
  
  # TO-DO: Find a less expensive way to do this
    
  def logout
    user = session[:user]
    connections = Connection.find(:all, :conditions => {:user_id => user.id, :expires_on => nil});    
    connections.each do |connection|      
         connection.expire!      
    end
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to :controller => 'user', :action => 'login'
  end
  
  def convert_to_human(bytes)
    kilobytes = bytes/1024
    if kilobytes < 1024
      return kilobytes.to_s + ' KB'
    end
    megabytes = bytes/1024**2
    if megabytes < 1024
      return megabytes.to_s + ' MB'
    end
    gigabytes = bytes/1024**3
    if gigabytes < 1024
      return gigabytes.to_s + ' GB'
    end
    terabytes = bytes/1024**4
    return terabytes.to_s + ' TB'
  end
  
end
