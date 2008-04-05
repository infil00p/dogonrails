class AddForwardurlToConnection < ActiveRecord::Migration
  def self.up
	add_column :connections, :forward_url, :string, :default => "http://www.freethenet.ca"
  end

  def self.down
	remove_column :connections, :forward_url
  end
end
