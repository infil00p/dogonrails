class ChangeUserRoleToString < ActiveRecord::Migration
  def self.up
    remove_column :users, :user_role
    add_column :users, :user_role, :string
  end

  def self.down
    remove_column :users, :user_role
    add_column :users, :user_role, :integer
  end
end
