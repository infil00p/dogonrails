class AddFbuidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fbuid, :string
  end

  def self.down
    remove_column :user, :fbuid
  end
end
