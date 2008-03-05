class WifidogController < ApplicationController
  session :off

  # fake garbage collection!
  before_filter :garbage_collect

  def auth
    # Only one auth protocol
    auth_1_0
  end

  def ping
    active_node = AccessNode.find_by_mac(params[:gw_id])
    if !active_node.nil?
      active_node.update_attributes(
          :sys_uptime => params[:sys_uptime],
          :sys_load => params[:sys_load],
          :sys_memfree => params[:sys_memfree],
          :wifidog_uptime => params[:wifidog_uptime],
          :remote_addr => request.remote_addr,
          :last_seen => Time.now
        )
    end
    render :text => "Pong"
  end

private

  def auth_1_0
    # Assume auth = 0
    auth = 0

    if !connection = Connection.find_by_token(params[:token])
      logger.info "Invalid token: #{params[:token]}"
    else 
      case params[:stage]
      when 'login':
        if connection.expired? or connection.used?
          logger.info "Tried to login with used or expired token: #{params[:token]}"
        elsif !BannedMac.find_by_mac(params[:mac]).nil?
          logger.info "Banned MAC tried logging in at " + Time.now.to_s + " with MAC: " + params[:mac]
        else
          connection.use!
          auth = 1
        end
      when 'counters':
        if !connection.expired?
          if BannedMac.find_by_mac(params[:mac]).nil?
            auth = 1
            connection.update_attributes({
                :mac => params[:mac],
                :ip => params[:ip],
                :incoming_bytes => params[:incoming],
                :outgoing_bytes => params[:outgoing]
              })                        
          else
              connection.expire!
          end
        end
      when 'logout':
        logger.info "Logging out: #{params[:token]}"
        connection.expire!
      else          
        logger.info "Invalid stage: #{params[:stage]}"
      end    
    end
    render :text => "Auth: #{auth}"
  end

end
