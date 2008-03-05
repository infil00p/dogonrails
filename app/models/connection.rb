class Connection < ActiveRecord::Base
  belongs_to :access_node
  belongs_to :user

  validates_presence_of :access_node_id
  validates_presence_of :user_id


  class << self
    
    def list_by_date(page, date, node)
      if node.nil?
        paginate :per_page => 20, :page => page, :conditions => ['used_on > ?', date]
      else
        paginate :per_page => 20, :page => page, :conditions => ['used_on > ? AND access_node_id = ?', date, node.id]
      end
    end 
    
    def list_by_mac(page,mac,date)
      paginate :per_page => 20, :page => page, :conditions => ['used_on > ? AND mac = ?', date, mac]
    end
        
  end

  def expired?
    return false if self.expires_on.nil?
    self.expires_on < Time.now
  end

  def used?
    return true if self.used_on
  end

  def expire!
    self.update_attribute("expires_on", Time.now)
    self.save
  end

  def use!
    self.update_attribute("used_on", Time.now)
  end
  


end
