module ActiveRecord
  module Acts
    module Authenticated
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_authenticated(options = {})
          has_and_belongs_to_many :roles, :join_table => "#{table_name}_roles"
          write_inheritable_attribute(:acts_as_authenticated_options, {:signin_id => options[:signin_id] || "user_name",
                                                                       :password => options[:password] || "password"})
          class_inheritable_reader :acts_as_authenticated_options
          include ActiveRecord::Acts::Authenticated::InstanceMethods
          extend ActiveRecord::Acts::Authenticated::SingletonMethods
        end
      end
      
      module SingletonMethods
        def authenticate(signin_id, hashed_password)
          find(:first, :conditions => ["#{acts_as_authenticated_options[:signin_id]}=? AND #{acts_as_authenticated_options[:password]}=?", signin_id, hashed_password])
        end

        def hash_password(password)
          Digest::SHA1.hexdigest(password || "")
        end
      end
      
      module InstanceMethods
        def password=(passwd)
          @attributes[acts_as_authenticated_options[:password].to_s] = self.class.hash_password(passwd)
        end
        
        def permissions
          self.roles.map { |r| r.permissions }.join(" ")
        end

        def module_hash
          modules = {}
          self.permissions.split(" ").each { |mp|
            mp =~ /^(.+):([a-z]+)$/
            module_name, permissions = $1, $2.unpack('c*').map { |c| c.chr }
            if modules[module_name].nil?
              modules[module_name] = permissions
            else
              modules[module_name] = modules[module_name].concat(permissions).uniq
            end
          }
          return modules
        end

        def permission?(*module_permission)
          module_permission.flatten!
          module_permission.each { |mp|
            mp =~ /^(.+):([a-z]+)$/
            module_name, permissions = $1, $2
            return false if not self.module_permission?(module_name, permissions)
          }
          return true
        end

        def module_permission?(module_name, permissions)
          permissions = permissions.unpack('c*').map { |c| c.chr }.uniq
          my_modules = self.module_hash
          return false if my_modules[module_name].nil?
          return (my_modules[module_name] & permissions).sort == permissions.sort
        end
      end
    end
  end
end