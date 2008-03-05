class AuthModelGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions class_name
      m.template "model_template.rb", 
                 "app/models/#{file_name}.rb"
      m.template "fixtures/users.rb",
                 "db/migrate/fixtures/#{file_name.pluralize}.yml"
      m.template "fixtures/roles.rb",
                 "db/migrate/fixtures/roles.yml"
      m.template "fixtures/users_roles.rb",
                 "db/migrate/fixtures/#{file_name.pluralize}_roles.yml"
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "access_control_support"
    end
  end
end