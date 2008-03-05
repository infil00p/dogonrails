class GiveUsersPrivacy < ActiveRecord::Migration
  def self.up
    add_column :users, "private", :boolean, :default => false
  end

  def self.down
    remove_column :users, :private
  end
end
