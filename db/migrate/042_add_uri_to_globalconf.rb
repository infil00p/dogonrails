class AddUriToGlobalconf < ActiveRecord::Migration
  def self.up
    add_column :globalconfs, :auth_url, :string, :default => "auth.freethenet.ca"
  end

  def self.down
    remove_column :globalconfs, :auth_url
  end
end
