class FixNodeSettingUpdate < ActiveRecord::Migration
  def self.up
    remove_column :node_settings, :update
    add_column :node_settings, :node_update, :boolean, :default => true
  end

  def self.down
    remove_column :node_settings, :node_update
  end
end
