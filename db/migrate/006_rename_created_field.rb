class RenameCreatedField < ActiveRecord::Migration
  def self.up
    rename_column :tokens, :created, :created_on
    rename_column :tokens, :ipaddr, :remote_addr
    add_column :tokens, :updated_on, :timestamp
    add_column :tokens, :user_id, :integer
  end

  def self.down
    remove_column :tokens, :user_id
    remove_column :tokens, :updated_on
    rename_column :tokens, :remote_addr, :ipaddr
    rename_column :tokens, :created_on, :created
  end
end
