class AddDefaultValueToConnections < ActiveRecord::Migration
  def self.up
    change_column_default :connections, :incoming_bytes, 0
    change_column_default :connections, :outgoing_bytes, 0
  end

  def self.down
  end
end
