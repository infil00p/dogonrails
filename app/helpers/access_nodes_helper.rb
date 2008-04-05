module AccessNodesHelper
  
  def last_seen_in_words(time)
    (time.nil? ? "Never" : time_ago_in_words(time))
  end
  
  def all_data_uploaded
    connections = Connection.find(:all)
    bytes_up = 0;
    connections.each do |connection|
      bytes_up += connection.outgoing_bytes
    end
    return convert_to_human(bytes_up)
  end
  
  def all_data_downloaded
    connections = Connection.find(:all)
    bytes_down = 0;
    connections.each do |connection|
      bytes_down += connection.incoming_bytes
    end
    return convert_to_human(bytes_down)
  end  

  def total_usage_kbytes
    connections = Connection.find(:all)
    bytes_total = 0;
    connections.each do |connection|
      bytes_total += connection.outgoing_bytes + connection.incoming_bytes
    end
    return bytes_total/1024
  end

  def total_user_count
    User.find(:all).length
  end
    

  def options_for_owners(current_user)
    users = User.find(:all, :conditions => ['email NOT LIKE ?', '%@dogonrails.org'])
    output = ""
    users.each do |user|
      if user == current_user
        output += '<option value="' + user.id.to_s + '" selected >' + user.login + '</option>'
      else
        output += '<option value="' + user.id.to_s + '">' + user.login + '</option>'
      end
    end
    output
  end
end
