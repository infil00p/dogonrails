class String
  def to_class
    eval(self.camelcase)
  end
end

class Symbol
  def to_class
    self.to_s.to_class
  end
end

module ActionView
  module Helpers
    module UrlHelper
      alias_method :force_link_to, :link_to

      def link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
        url = options.is_a?(String) ? options : self.url_for(options, *parameters_for_method_reference)
        rs = ActionController::Routing::Routes 
        url = rs.recognize_path(url)
        call_authorization_chain(url) ? force_link_to(name, options, html_options, *parameters_for_method_reference) : ""
      end

      private
        def call_authorization_chain(url)
          controller = "#{url[:controller]}_controller".to_class
          action_name = url[:action]
          if controller.respond_to? :authorization_chain
            authorizations = controller.authorization_chain.find_all { |a| a.action?(action_name) }
            collected_permissions = authorizations.collect { |a| a.permissions }.flatten
            return false if session[ApplicationController.authentication_options[:model]].nil? and not collected_permissions.empty?
            return true if session[ApplicationController.authentication_options[:model]].nil? and collected_permissions.empty?
            return false unless session[ApplicationController.authentication_options[:model]].permission?(collected_permissions)
          end
          return true
        end
    end
  end
end