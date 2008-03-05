class AddLatAndLngToNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, "lat", :float
    add_column :access_nodes, "lng", :float
    add_column :access_nodes, "ele", :float
  end

  def self.down
    remove_column :access_nodes, :lat
    remove_column :access_nodes, :lng
    remove_column :access_nodes, :ele
  end
end
