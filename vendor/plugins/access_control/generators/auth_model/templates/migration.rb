require 'active_record/fixtures'

class AccessControlSupport < ActiveRecord::Migration
  def self.up
    create_table :<%= class_name.pluralize.downcase %> do |t|
      t.column :user_name, :string, :null => false
      t.column :full_name, :string
      t.column :password, :string, :size => 40
    end
    
    create_table :roles do |t|
      t.column :name, :string, :null => false
      t.column :permissions, :text
    end
    
    create_table :<%= class_name.pluralize.downcase %>_roles, :id => false do |t|
      t.column :user_id, :integer, :null => false
      t.column :role_id, :integer, :null => false
    end
    
    directory = File.join(File.dirname(__FILE__), "fixtures") 
    Fixtures.create_fixtures(directory, "<%= class_name.pluralize.downcase %>")
    Fixtures.create_fixtures(directory, "roles")
    Fixtures.create_fixtures(directory, "<%= class_name.pluralize.downcase %>_roles")
  end

  def self.down
    drop_table :<%= class_name.pluralize.downcase %>_roles
    drop_table :roles
    drop_table :<%= class_name.pluralize.downcase %>
  end
end