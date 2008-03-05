require 'uuidtools'

class SystemMailer < ActionMailer::Base

  def auth_delivery(user, url)
    setup_email(user)
    @subject += 'Please activate your account'
    body(
      :user => user, 
      :url => url
    )
  end

  def quota_email(access_node)
    setup_email(access_node.owner)
    @subject += 'Your node has gone over quota!!!'
    body(
      :user => user
    )
  end

  def setup_email(user)
    @subject      = '[FreeTheNet Vancouver] '
    @recipients   = user.is_a?(User) ? user.email : user
    @from         = 'system@freethenet.ca'
    @sent_on      = Time.now
  end

end
