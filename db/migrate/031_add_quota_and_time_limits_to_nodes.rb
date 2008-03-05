class AddQuotaAndTimeLimitsToNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, :time_limit, :integer
    add_column :access_nodes, :quota, :integer
  end

  def self.down
    remove_column :access_nodes, :time_limit
    remove_column :access_nodes, :quota
  end
end
