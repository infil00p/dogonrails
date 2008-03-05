desc "Create a splash page user for the TOU disclaimer code"
task :add_splash_user => :environment do
     spash_user = User.new()
     spash_user.activated = true;
     spash_user.login = "splash_user"
     splash_user.email = "splash_user@freethenet.ca"
     splash_user.save
end