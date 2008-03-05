require 'digest/sha1'

class <%= class_name %> < ActiveRecord::Base
  acts_as_authenticated
end