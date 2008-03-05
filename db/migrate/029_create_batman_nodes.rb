class CreateBatmanNodes < ActiveRecord::Migration
  def self.up
    create_table :batman_nodes do |t|
      t.column  :access_node_id, :integer
      t.column  :gateway_ip, :string
      t.column  :gateway, :boolean
      t.column  :last_ip, :string
      t.column  :mac, :string
      t.column  :robin_ver, :string
      t.column  :batman_ver, :string
      t.column  :ssid, :string
      t.column  :pssid, :string
      t.column  :memfree, :integer
      t.column  :uptime, :string
      t.column  :gw_qual, :integer
      t.column  :routes, :string
      t.column  :hops, :integer
      t.column  :nbs, :string
      t.column  :rank, :string
    end
  end

  def self.down
    drop_table :batman_nodes
  end
end
