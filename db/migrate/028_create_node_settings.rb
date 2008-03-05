class CreateNodeSettings < ActiveRecord::Migration
  def self.up
    create_table :node_settings do |t|
      t.column  :access_node_id, :integer
      t.column  :public_ssid, :string, :default => 'FreeTheNet.ca'
      t.column  :download_limit, :integer, :default => 0
      t.column  :upload_limit, :integer, :default => 0
      t.column  :private_ssid, :string, :default => 'FreeTheNet.ca_Secure'
      t.column  :private_passwd, :string, :default => 'm3rhak1'
      t.column  :node_passwd, :string, :default => 'm3rhak1'
    end
  end

  def self.down
    drop_table :node_settings
  end
end
