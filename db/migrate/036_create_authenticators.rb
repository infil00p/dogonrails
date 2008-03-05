class CreateAuthenticators < ActiveRecord::Migration
  def self.up
    create_table :authenticators do |t|
      t.string  "auth_name" ,:default => "DogOnRails Local"
      t.string  "auth_type" ,:default => 'local' # We support both Local and RADIUS
      t.string  "auth_server"
      t.string  "dictionary_path"
      t.string  "auth_secret"
      t.integer "auth_timeout", :default => 5
      t.integer "access_node_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :authenticators
  end
end
