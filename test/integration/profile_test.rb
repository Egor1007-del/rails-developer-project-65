require "test_helper"

class ProfileTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular)
  end
  test "signed in user can access profile" do
    sign_in(@user)

    get profile_path

    assert_response :success
  end

  test "guest cannot access profile" do
    get profile_path

    assert_redirected_to root_path
  end

  test "user can send own draft bulletin to moderation" do
    sign_in(@user)

    bulletin = bulletins(:draft)

    patch to_moderate_bulletin_path(bulletin)

    assert_redirected_to profile_path
    assert bulletin.reload.under_moderation?
  end

  test "user can archive own bulletin" do
    sign_in(@user)

    bulletin = bulletins(:draft)

    patch archive_bulletin_path(bulletin)

    assert_redirected_to profile_path
    assert bulletin.reload.archived?
  end
end
