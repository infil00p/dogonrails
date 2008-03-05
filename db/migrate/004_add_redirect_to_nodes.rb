class AddRedirectToNodes < ActiveRecord::Migration
  def self.up
    add_column :access_nodes, "redirect_url", :string
  end

  def self.down
    drop_column :access_nodes, :redirect_url
  end
end
