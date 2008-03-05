# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def convert_to_human(bytes)
    kilobytes = bytes/1024
    if kilobytes < 1024
      return kilobytes.to_s + ' KB'
    end
    megabytes = bytes/1024**2
    if megabytes < 1024
      return megabytes.to_s + ' MB'
    end
    gigabytes = bytes/1024**3
    if gigabytes < 1024
      return gigabytes.to_s + ' GB'
    end
    terabytes = bytes/1024**4
    return terabytes.to_s + ' TB'
  end
  
  def global_conf
    Globalconf.find(1)
  end
  
end
