class Flag < ActiveRecord::Base
  serialize :flag, Symbol
  belongs_to :flaggable, :polymorphic => true
  
  # NOTE: Flags belong to a user
  belongs_to :user

  # A user can flag a specific flaggable with a specific flag once
  validates_prescence_of :flag
  validates_uniqueness_of :user_id, :scope => [:flaggable_id, :flaggable_type, :flag]
  
  # Helper class method to lookup all flags assigned
  # to all flaggable types for a given user.
  def self.find_flags_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end
  
  # Helper class method to look up all flags for 
  # flaggable class name and flaggable id.
  def self.find_flags_for_flaggable(flaggable_str, flaggable_id)
    find(:all,
      :conditions => ["flaggable_type = ? and flaggable_id = ?", flaggable_str, flaggable_id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up a flaggable object
  # given the flaggable class name and id 
  def self.find_flaggable(flaggable_str, flaggable_id)
    flaggable_str.constantize.find(flaggable_id)
  end
end