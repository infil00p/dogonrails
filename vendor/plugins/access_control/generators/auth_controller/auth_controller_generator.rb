class AuthControllerGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions class_name
      m.template "controller_template.rb", 
                 "app/controllers/#{file_name}_controller.rb"
      m.directory File.join("app/views", file_name)
      m.template "signin_template.rb",
                 "app/views/#{file_name}/signin.rhtml"
    end
  end
end