module AccessControl
  module AuthenticationSystem
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def authenticate(options={})
        write_inheritable_attribute(:authentication_options, {:signin => options[:signin] || {:controller => "authentication", :action => "signin"},
                                                              :model => options[:model] || :user})
        class_inheritable_reader :authentication_options
        before_filter :check_authentication, options
        helper_method :current_user
      end
      
      def skip_authentication(options={})
        skip_before_filter :check_authentication, options
      end
      alias no_authentication skip_authentication
      
      def skip_authentication_for(*actions)
        skip_before_filter :check_authentication, :only => actions
      end
      alias no_authentication_for skip_authentication_for
    end
    
    module InstanceMethods
      def check_authentication
        if current_user
          session[authentication_options[:model]] = authentication_options[:model].to_class.find(current_user.id, :include => :roles)
        else
          session[:intended_uri] = request.request_uri
          flash[:notice] = "You have to sign in first."
          redirect_to authentication_options[:signin]
          return false
        end
      end
      
      def current_user
        session[authentication_options[:model]]
      end
    end
  end
  
  
  module AuthorizationSystem
    def self.included(base)
      base.extend(ClassMethods)  
    end
    
    module ClassMethods
      def authorize(*permissions)
        append_authorization(permissions)
      end
      
      private
        class Authorization
          attr_reader :permissions, :included_actions, :excluded_actions
          
          def initialize(permissions, options={})
            @permissions = permissions
            @included_actions = [options[:only]].flatten.map(&:to_s)
            @excluded_actions = [options[:except]].flatten.map(&:to_s)
          end
          
          def action?(action)
            return true if @included_actions.empty? and @excluded_actions.empty?
            return true if @included_actions.include?(action)
            return false if @excluded_actions.include?(action)
          end
        end
      
        def append_authorization(*permissions)
          permissions, conditions = extract_authorization_conditions(permissions)
          write_inheritable_array(:authorization_chain,  [Authorization.new(permissions, conditions)])
          class_inheritable_reader :authorization_chain
          before_filter(conditions) do |controller|
            controller.check_authorization(*permissions)
          end
        end
        
        def extract_authorization_conditions(*permissions)
          permissions.flatten!
          conditions = permissions.last.is_a?(Hash) ? permissions.pop : {}
          return permissions, conditions
        end
    end
    
    module InstanceMethods
      def check_authorization(*permissions)
        if not current_user.permission?(*permissions)
          flash[:notice] = "You have not the permissions to call this action."
          session[:intended_uri] = request.request_uri
          redirect_to ApplicationController.authentication_options[:signin]
          return false
        end
      end
    end
  end
  
  module Extensions
    def link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
      original_link_to name, options, html_options, *parameters_for_method_reference
    end
  end
end