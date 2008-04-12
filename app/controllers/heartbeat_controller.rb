class HeartbeatController < ApplicationController

def index 

end

# I wish that it was a Rails form that was talking to this instead of 
# a shell script!  I may have to write an ugly route for this rule!
def update
  node_updating = AccessNode.find_by_mac(params[:mac])
  if node_updating.batman_node.nil?
    node_updating.batman_node = BatmanNode.new
  end
  batman_node = node_updating.batman_node
  batman_node.ssid = params[:ssid]
  batman_node.gateway_ip = params[:gw]
  batman_node.last_ip = params[:ip]
  batman_node.mac = params[:mac]
  batman_node.robin_ver = params[:robin]
  batman_node.batman_ver = params[:batman]
  batman_node.pssid = params[:pssid]
  batman_node.gw_qual = params["gw-qual"]
  batman_node.routes = params[:routes]
  batman_node.hops = params[:hops]
  batman_node.nbs = params[:nbs]
  batman_node.rank = params[:rank]
  if batman_node.gw_qual == 255
    batman_node.gateway = true
  end
  batman_node.save
  if node_updating.node_setting.nil?
     config = NodeSetting.new
     node_updating.node_setting = config
     config.save!
  end
  @node_settings = node_updating.node_setting
  render :layout => false;
  
end

end
