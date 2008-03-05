desc "Create the default settings to be updated"
task :add_globals => :environment do
     global = Globalconf.new()
     global.network_name = "DogOnRails Authentication Server"
     global.center_lat = 49.27240
     global.center_lng = -123.11562
     global.ganal = '';
     global.gmaps_key = "GMAPS KEY GOES HERE"
     global.zoom = 13
     global.save
end