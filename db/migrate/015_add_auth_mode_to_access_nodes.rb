class AddAuthModeToAccessNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, :auth_mode, :integer
  end

  def self.down
    remove_column :access_nodes, :auth_mode
  end
end
