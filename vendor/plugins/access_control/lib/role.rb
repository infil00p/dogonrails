class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def permissions=(perms)
    @attributes["permissions"] = perms.split(" ").uniq.join(" ")
  end
end