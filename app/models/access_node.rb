require 'gruff'
include GeoKit::Geocoders

class AccessNode < ActiveRecord::Base
  
  acts_as_mappable  
  has_many :connections
  has_many :notices
  belongs_to :user
  has_many :online_users, :source => :user, :through => :connections, :conditions => "used_on is not null and (expires_on is null or expires_on > NOW())"
  has_many :online_connections, :class_name => "Connection", :conditions => "used_on is not null and (expires_on is null or expires_on > NOW())"

  has_one :batman_node
  has_one :node_setting
  has_one :authenticator

  validates_presence_of :name, :message => 'is required'
  validates_presence_of :mac, :message => 'is required'

  validates_uniqueness_of :name, :message => 'must be unique'
  validates_uniqueness_of :mac, :message => 'must be unique'

  validates_format_of :mac, :with => /^[0-9A-F]+$/, :message => "is invalid, example: 0022446688FA"
  validates_length_of :mac, :is => 12, :message => "is invalid, example: 0022446688FA"

  AuthModes = {
    :normal => "NORMAL",
    :splash => "SPLASH",
    :openid => "OPENID"
  }

  validates_inclusion_of :auth_mode, :in => AuthModes.values

  before_validation :sanitize_mac, :geocode_addr
 
  after_create :add_settings

  class << self
    
    def check_quotas
      nodes = AccessNode.find(:all)
      nodes.each do | node |
	     unless node.quota.nil?
        	hard_quota = node.quota * 1024**3
        		if total_aggregate_bandwidth > hard_quota && hard_quota > 0
          			SystemMailer.deliver_quota_email(node)
        		end
      		end
	     end
    end
  end
  
  def owner
    self.user
  end

  def sanitize_mac
    self.mac = AccessNode.sanitize_mac_address(self.mac)
  end
  
  def geocode_addr
	unless address.nil?
      		res=MultiGeocoder.geocode(self.address)
      		self.lat = res.lat
      		self.lng = res.lng
	end
  end

  def self.find_by_mac(mac)
    self.find(:first, :conditions => ["mac = ?", sanitize_mac_address(mac)])
  end

  def self.sanitize_mac_address(mac)
    return nil if mac.nil?
    mac.gsub(/[:-]/, "").upcase
  end

  def bandwidth_graph(timespan)
    graph_conn = Connection.find(:all, :conditions => ['used_on > ? AND access_node_id = ?', timespan, self.id])
    points_up = []
    points_down = []
    values_up = 0
    values_down = 0
    conn_day = graph_conn.first.used_on 
    point_markers = {}
    key = 0
    graph_conn.each do |conn|
      points_down << conn.incoming_bytes/1024**2
      points_up << conn.outgoing_bytes/1024**2
      if key.divmod(2).last == 0
      	point_markers[key] = conn.used_on.month.to_s + "/" + conn.used_on.day.to_s
      end
      key += 1
    end
    graph = Gruff::Line.new(640)
    graph.title = "Bandwidth (in MB)"
    graph.data("Upstream", points_up)
    graph.data("Downstream", points_down)
    graph.labels = point_markers
    filename = RAILS_ROOT + '/public/images/' + self.mac + '_bandwidth.png'
    graph.write(filename)
  end
  
  def total_up
     bytes_up = 0
     connections = self.connections.find(:all, :conditions => [ 'created_on > ?', Time.now - 1.month ])
     connections.each do |connection|
     unless connection.outgoing_bytes.nil?
        bytes_up += connection.outgoing_bytes
     end
    end
    return bytes_up
  end
  
  def total_down
     bytes_down = 0
     connections = self.connections.find(:all, :conditions => [ 'created_on > ?', Time.now - 1.month ])
     connections.each do |connection|
      unless connection.incoming_bytes.nil?  
        bytes_down += connection.incoming_bytes
      end
    end
    return bytes_down
  end
  
  def aggregate_bandwidth_up
    if self.batman_node.nil? || !self.batman_node.gateway
      return total_up
    else
      agg_up = total_up
      ip_addr = self.batman_node.last_ip
      children = BatmanNode.find_by_gateway(ip_addr)
      unless children.nil? 
      	children.each do |child|
        	agg_up += child.access_node.total_up
      	end
      end
      return agg_up
    end
  end
  
  def aggregate_bandwidth_down
    if self.batman_node.nil? || !self.batman_node.gateway
      return total_down
    else
      agg_down = total_down
      ip_addr = self.batman_node.last_ip
      children = BatmanNode.find_by_gateway(ip_addr)
      unless children.nil?
      	children.each do |child|
        	agg_down += child.access_node.total_down
      	end
      end
      return agg_down
    end
  end
  
  def total_aggregate_bandwidth
    aggregate_bandwidth_up + aggregate_bandwidth_down
  end
  
  # This takes in a certain interval
  def usage_graph(timespan)
    graph_conn = Connection.find(:all, :conditions => ['used_on > ? AND access_node_id = ?', timespan, self.id])
    points = []
    labels = {}
    # This can take day, hour and minute to generate graphs
    date = nil
    value = 0
    key = 0
    graph_conn.each do |conn|      
      if conn.used_on.day == date
        value += 1
      else
        points << value
        value = 0
	labels[key] = conn.used_on.month.to_s + "/" + conn.used_on.day.to_s
        date = conn.used_on.day
      end 
      key += 1
    end
    graph = Gruff::Line.new(640)
    graph.title = "Connections"
    graph.data("Connections", points)
    graph.labels = labels
    filename = RAILS_ROOT + '/public/images/' + self.mac + '_usage.png'
    graph.write(filename)
  end

  def add_settings
  	self.node_setting = NodeSetting.new
	self.node_setting.save!
  end

end
