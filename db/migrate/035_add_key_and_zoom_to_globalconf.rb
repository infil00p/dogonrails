class AddKeyAndZoomToGlobalconf < ActiveRecord::Migration
  def self.up
    add_column :globalconfs, :gmaps_key, :string
    add_column :globalconfs, :zoom, :integer
  end

  def self.down
    remove_column :globalconfs, :gmaps_key
    remove_column :globalconfs, :zoom
  end
end
