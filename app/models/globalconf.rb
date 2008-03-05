class Globalconf < ActiveRecord::Base
  
  def logo=( blob )
    directory   = RAILS_ROOT + "/public/logo"
    name        = "logo"
    filename    = "#{ name }.png"
    iconname    = "#{ name }_icon.png"
    full_path   = File.join directory, filename
    icon_path   = File.join directory, iconname
    
    # create the directory if it doesn't exist
    FileUtils.mkdir_p directory
    
    # write to the filesystem
    File.open( full_path, 'wb' ) do |file|
      file.puts blob.read
    end
        
    # resize to thumnail here
    img = Magick::Image.read( full_path ).first
    logo = img.resize_to_fit! 90, 90
    
    # write to filesystem
    logo.write full_path
      
    # set the path of the upload relative to the root of the web
    self.logo_path = "/images/" + filename
  end
  
end
