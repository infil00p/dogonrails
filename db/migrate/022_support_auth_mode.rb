class SupportAuthMode < ActiveRecord::Migration
  def self.up
    execute("update access_nodes set auth_mode = 'NORMAL'")
    add_column :access_nodes, :couponcode_required, :boolean, :default => false
  end

  def self.down
    throw ActiveRecord::IrreversibleMigration
  end
end
