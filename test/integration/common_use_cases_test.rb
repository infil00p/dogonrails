require "#{File.dirname(__FILE__)}/../test_helper"

class CommonUseCasesTest < ActionController::IntegrationTest
  fixtures :users, :connections, :access_nodes

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_create_and_use_user
    get "/user/signup"
    assert_response :success
    assert_template "user/signup"

    post "/user/signup",
      "user[login]" => "bob",
      "user[email]" => "bob@dole.com",
      "user[password]" => "bobby",
      "user[password_confirmation]" => "bobby"
    assert_redirected_to :controller => "user"
    follow_redirect!

    # Fake that we got the validation email and activate our code
    user = User.find_by_login("bob")
    post "/user/activate",
      :code => user.activation_code
    #assert_response :success

    # Support legacy
    get "/login", :gw_id => "d3adb33fd3ad", :gw_port => "2060", :gw_address => "1.1.1.1"
    assert_response :success
    assert_template "user/login"

    # Fake node and router
    get "/user/login", :gw_id => "d3adb33fd3ad", :gw_port => "2060", :gw_address => "1.1.1.1"
    assert_response :success
    assert_template "user/login"

    post "/user/authenticate",
      :username => "bob",
      :password => "bobby",
      :gw_id => "d3adb33fd3ad",
      :gw_port => "2060",
      :gw_address => "1.1.1.1"

    # Find the newly created connection
    connection = Connection.find(:first, :conditions => ["user_id = ?", user.id])

    assert_redirected_to "http://1.1.1.1:2060/wifidog/auth?token=#{connection.token}"

    # Pass the token and we should get Auth: 1
    post "/auth", :stage => "login", :token => connection.token
    assert_equal @response.body, "Auth: 1"

    # Make sure the token is marked with used_on
    connection.reload
    assert connection.used?

    # Pass it again, it should not work, it's been used
    post "/auth", :stage => "login", :token => connection.token
    assert_equal "Auth: 0", @response.body

    # Log out the user
    post "/auth", :stage => "logout", :token => connection.token
    assert_equal "Auth: 0", @response.body

    # Make sure the connection is expired
    connection.reload
    assert connection.expired?
  end

  def test_node_pings
    get "/ping", :gw_id => "d3adb33fd3ad", :sys_uptime => "2222222", :sys_load => "2.0", :sys_memfree => "256", :wifidog_uptime => "1000000"
    assert_response :success
    assert_equal @response.body, "Pong"

    # Make sure it updated the stats for real
    node = AccessNode.find_by_mac("d3adb33fd3ad")
    assert_equal 2222222, node.sys_uptime
    assert_equal 2.0, node.sys_load
    assert_equal 256, node.sys_memfree
    assert_equal 1000000, node.wifidog_uptime
  end

  def test_counters
  end

  def test_logout
  end
end
