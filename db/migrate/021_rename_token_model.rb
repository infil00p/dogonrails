class RenameTokenModel < ActiveRecord::Migration
  def self.up
    rename_table :tokens, :connections
  end

  def self.down
    rename_table :connections, :tokens
  end
end
