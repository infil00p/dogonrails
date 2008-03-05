class CreateSystemSettings < ActiveRecord::Migration
  def self.up
    create_table :system_settings do |t|
      t.column :name,   :string,  :null => false
      t.column :value,  :text,    :null => false
    end
    add_index :system_settings, [:name], :unique => true
  end

  def self.down
    drop_table :system_settings
  end
end
