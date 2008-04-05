class AddCustomPosToAccessNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, :custom_pos, :boolean, :default=>false
  end

  def self.down
    remove_column :access_nodes, :custom_pos
  end
end
