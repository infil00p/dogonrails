class AddOwnerToAccessNode < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, "user_id", :integer
  end

  def self.down
    remove_column :access_nodes, :user_id
  end
end
