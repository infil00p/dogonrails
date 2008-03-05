require 'access_control'
require 'acts_as_authenticated'
require File.dirname(__FILE__) + '/lib/role'
require File.dirname(__FILE__) + '/lib/extensions'

ActionController::Base.send(:include, AccessControl::AuthenticationSystem::InstanceMethods)
ActionController::Base.send(:include, AccessControl::AuthenticationSystem)
ActionController::Base.send(:include, AccessControl::AuthorizationSystem::InstanceMethods)
ActionController::Base.send(:include, AccessControl::AuthorizationSystem)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Authenticated)