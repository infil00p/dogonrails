class AddAddressToAccessNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, :address, :string
  end

  def self.down
    drop_column :access_nodes, :address
  end
end
