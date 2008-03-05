class CreateBannedMacs < ActiveRecord::Migration
  def self.up
    create_table :banned_macs do |t|
      t.column :mac,  :string
      t.column :banned_at, :datetime
    end
  end

  def self.down
    drop_table :banned_macs
  end
end
