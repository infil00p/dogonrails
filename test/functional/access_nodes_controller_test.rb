require File.dirname(__FILE__) + '/../test_helper'
require 'access_nodes_controller'

# Re-raise errors caught by the controller.
class AccessNodesController; def rescue_action(e) raise e end; end

class AccessNodesControllerTest < Test::Unit::TestCase
  fixtures :access_nodes

  def setup
    @controller = AccessNodesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = access_nodes(:one).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:access_nodes)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:access_node)
    assert assigns(:access_node).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:access_node)
  end

  def test_create
    num_access_nodes = AccessNode.count

    post :create, :access_node => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_access_nodes + 1, AccessNode.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:access_node)
    assert assigns(:access_node).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

end
