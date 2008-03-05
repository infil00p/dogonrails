class AddMacToAccessNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, "track_mac", :boolean
  end

  def self.down
    remove_column :access_nodes, :track_mac
  end
end
