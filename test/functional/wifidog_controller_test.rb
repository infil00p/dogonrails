require File.dirname(__FILE__) + '/../test_helper'
require 'wifidog_controller'

# Re-raise errors caught by the controller.
class WifidogController; def rescue_action(e) raise e end; end

class WifidogControllerTest < Test::Unit::TestCase
  def setup
    @controller = WifidogController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
