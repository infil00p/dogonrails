class ChangeAuthModeToString < ActiveRecord::Migration
  def self.up
    change_column :access_nodes, :auth_mode, :string
    add_column :access_nodes, :remote_addr, :string
    remove_column :tokens, :expired
    rename_column :tokens, :expires, :expires_on
  end

  def self.down
    rename_column :tokens, :expires_on, :expires
    add_column :tokens, :expired, :boolean
    remove_column :access_nodes, :remote_addr
    change_column :access_nodes, :auth_mode, :integer
  end
end
