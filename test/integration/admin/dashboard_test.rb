require "test_helper"

class AdminDashboardTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:regular)
  end

  test "admin can access admin page" do
    sign_in(users(:admin))

    get admin_bulletins_path

    assert_response :success
  end

  test "regular user cannot access admin page" do
    sign_in(users(:regular))

    get admin_bulletins_path

    assert_redirected_to root_path
    follow_redirect!
    assert_match I18n.t("layouts.web.admin.flash.admins_only"), response.body
  end

  test "guest cannot access admin page" do
    get admin_bulletins_path

    assert_redirected_to root_path
    follow_redirect!
    assert_match I18n.t("layouts.web.admin.flash.admins_only"), response.body
  end
end
