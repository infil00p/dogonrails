ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "user"
  #
  
  # Support current protocol's URLS
  map.connect 'login', :controller => "user", :action => "login"
  map.connect 'auth', :controller => "wifidog", :action => "auth"
  map.connect 'ping', :controller => "wifidog", :action => "ping"
  map.connect 'signup', :controller => "user", :action => "signup"
  map.connect 'portal/:gw_id', :controller => "portal", :action => "index"

  # Support ROBIN-like Routes
  map.connect 'update', :controller => "heartbeat", :action => "update"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id?:page'
  map.connect ':controller/:action?:mac'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
