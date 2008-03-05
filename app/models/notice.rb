class Notice < ActiveRecord::Base

  belongs_to :user
  belongs_to :access_node

  class << self    
    def list(page)
        paginate :per_page => 20, :page => page 
    end   
  end

end
