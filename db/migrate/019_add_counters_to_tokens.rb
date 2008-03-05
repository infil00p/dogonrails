class AddCountersToTokens < ActiveRecord::Migration
  def self.up
    add_column :tokens, :ip, :string
    add_column :tokens, :mac, :string
    add_column :tokens, :incoming_bytes, :integer, :limit => 11
    add_column :tokens, :outgoing_bytes, :integer, :limit => 11
  end

  def self.down
    remove_column :tokens, :ip
    remove_column :tokens, :mac
    remove_column :tokens, :outgoing_bytes
    remove_column :tokens, :incoming_bytes
  end
end
