require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false

  before_save :encrypt_password

  after_save :assign_admin
  
  has_many :access_nodes
  has_many :notices
  has_many :connections

  ROLE_ADMIN = "admin"
  ROLE_SPLASH = "splash"

  class << self
    
    def list(page)
        paginate :per_page => 20, :page => page 
    end   
  end

  def role=(role)
    self.user_role = role
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def expire_all_connections
    self.connections.each {|c| c.expire!}
  end

  def activate!
    self.update_attribute("activated", true)
  end
  
  def fb_node_data
    users_online = 0
    self.access_nodes do |node|
      users_online += node.online_users.count
    end
    up_nodes = self.access_nodes.find(:all, :conditions => ['last_seen > ?', Time.now - 10.minutes])
    down_nodes = self.access_nodes.find(:all, :conditions => ['last_seen < ?', Time.now - 10.minutes])
    fbml_string = '<fb:name uid=' + self.fbuid + '" capitalize="true" /> currently has: <ul>'
    fbml_string += '<li>' + up_nodes.length.to_s + ' nodes online</li>'
    fbml_string += '<li>' + down_nodes.length.to_s + ' nodes offline </li>'
    fbml_string += '<li>' + users_online.to_s + ' users on their nodes now </li></ul>'
    fbml_string += '<a href="http://auth.dogonrails.net">Check Out FreeTheNet Now!</a>'
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def assign_admin
      if self.id == 1
        self.user_role = ROLE_ADMIN
      end
    end
end
