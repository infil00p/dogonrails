class AddGoogleAnalToGlobalconfs < ActiveRecord::Migration
  def self.up
    add_column :globalconfs, :ganal, :text
  end

  def self.down
    remove_column :global_confs, :ganal
  end
end
