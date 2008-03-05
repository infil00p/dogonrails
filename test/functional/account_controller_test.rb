require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_fail_login_and_not_redirect
    post :authenticate, :login => 'quentin', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
  end

  def test_should_require_login_on_signup
    create_user(:login => nil)
    assert assigns(:user).errors.on(:login)
    assert_response :success
  end

  def test_should_require_password_on_signup
    create_user(:password => nil)
    assert assigns(:user).errors.on(:password)
    assert_response :success
  end

  def test_should_require_password_confirmation_on_signup
    create_user(:password_confirmation => nil)
    assert assigns(:user).errors.on(:password_confirmation)
    assert_response :success
  end

  def test_should_require_email_on_signup
    create_user(:email => nil)
    assert assigns(:user).errors.on(:email)
    assert_response :success
  end

  def test_should_logout
    post :authenticate, :login => 'quentin', :password => 'quire'
    get :logout
    assert_nil session[:user]
    assert_response :redirect
  end

  protected
    def create_user(options = {})
      post :signup, :user => { :login => 'quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
