class CreateGlobalconfs < ActiveRecord::Migration
  def self.up
    create_table :globalconfs do |t|
      t.column :network_name, :string
      t.column :logo_path, :string
      t.column :center_lat, :string
      t.column :center_lng, :string
    end
  end

  def self.down
    drop_table :globalconfs
  end
end
