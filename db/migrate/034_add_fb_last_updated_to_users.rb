class AddFbLastUpdatedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_last_updated, :datetime
  end

  def self.down
    remove_column :users, :fb_last_updated
  end
end
