class AddTokenUsedOn < ActiveRecord::Migration
  def self.up
    add_column :tokens, :used_on, :timestamp
    add_column :access_nodes, :mac, :string
  end

  def self.down
    remove_column :access_nodes, :mac
    remove_column :tokens, :used_on
  end
end
