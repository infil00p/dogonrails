class RenameNodeIdToAccessNodeId < ActiveRecord::Migration
  def self.up
    rename_column "notices", :node_id, :access_node_id
    add_column :users, :activation_code, :string
    remove_column :users, :activated
    add_column :users, :activated, :boolean, :null => false, :default => false
    drop_table :activation_codes
  end

  def self.down
    create_table :activation_codes do |t|
      t.column :user_id, :integer
      t.column :activation_code, :string
    end
    rename_column :notices, :access_node_id, :node_id
    remove_column :users, :activation_code
    remove_column :users, :activated
    add_column :users, :activated, :boolean
  end
end
