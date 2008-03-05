class CreateAccessNodes < ActiveRecord::Migration
  def self.up
    create_table :access_nodes do |t|
      t.column :name,       :string
      t.column :sys_uptime, :int
      t.column :sys_load,   :int
      t.column :sys_memfree, :int
      t.column :wifidog_uptime, :int
      t.column :last_seen, :datetime
    end
  end

  def self.down
    drop_table :access_nodes
  end
end
