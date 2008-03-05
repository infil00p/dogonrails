class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
    t.column :token,      :string
    t.column :ipaddr,     :string    
    t.column :access_node_id,      :int, :default => 0
    t.column :created,    :datetime
    t.column :expires,    :datetime
    t.column :expired,    :int, :default => 0
    end
  end

  def self.down
    drop_table :tokens
  end
end
