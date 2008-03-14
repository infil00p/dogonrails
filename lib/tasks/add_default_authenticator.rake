desc "Add the default authenticator to the task and set the authentication to the default authenticator"
task :add_default_auth => :environment do
	auth = Authenticator.new
	auth.save!
	nodes = AccessNode.find(:all)
	nodes.each do |node|
		node.auth = auth
		node.save!
	end
end
