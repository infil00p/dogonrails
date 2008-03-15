class AddSettingsToNodeSettings < ActiveRecord::Migration
  def self.up
  	add_column :node_settings, :update, :boolean, :default => true
	add_column :node_settings, :upgrade, :boolean, :default => true
	add_column :node_settings, :force_reboot, :boolean, :default => true
	add_column :node_settings, :base, :string, :default => 'beta'
  end

  def self.down
	  remove_column :node_settings, :update
	  remove_column :node_settings, :upgrade
	  remove_column :node_settings, :force_reboot
	  remove_column :node_settings, :base
  end
end
