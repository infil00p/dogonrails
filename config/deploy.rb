set :application, "dogonrails"
set :user, "bowserj"
set :domain,  "#{ user }@auth.dogonrails.net"
set :deploy_to, "/var/www/dogonrails"
set :repository, "github.com:bowserj/dogonrails.git"
set :web, "apache"
set :ssh_flags, "-p 2223"

namespace :vlad do
  desc 'Does turnkey stuff'
  
  task :deploy => ['vlad:update', 'vlad:symlink', 'vlad:start']
  task :deploy_with_migrations => ['vlad:update', 'vlad:migrate', 'vlad:symlink', 'vlad:start']
  
  desc 'Symlinks your custom directories'
  remote_task :symlink, :roles => :app do
	run "rm /var/www/dogonrails/current/config/database.yml"
	run "ln -s /var/www/dogonrails/shared/database.yml /var/www/dogonrails/current/config/database.yml"
	run "ln -s /var/www/dogonrails/shared/facebook.yml /var/www/dogonrails/current/config/facebook.yml"
	run "ln -s /var/www/dogonrails/shared/logos /var/www/dogonrails/current/public/logo"
	run "ln -s /var/www/dogonrails/shared/tiny_mce /var/www/dogonrails/current/vendor/plugins/tiny_mce"
  end


end
