require "test_helper"

class AdminDashboardTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:regular)
  end

  test "admin can access admin page" do
    sign_in(users(:admin))

    get admin_root_path

    assert_response :success
  end

  test "regular user cannot access admin page" do
    sign_in(users(:regular))

    get admin_root_path

    assert_redirected_to root_path
  end

  test "guest cannot access admin page" do
    get admin_root_path

    assert_redirected_to root_path
  end
end
