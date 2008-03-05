class AddAuthenticatorsToAccessNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, :authenticator_id, :integer
  end

  def self.down
    remove_column :access_nodes, :authenticator_id
  end
end
