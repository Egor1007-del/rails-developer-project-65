require "test_helper"

class AdminBulletinsTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
  end

  test "admin can view bulletins" do
    sign_in(@admin)

    get admin_bulletins_path

    assert_response :success
  end

  test "admin can view moderation page" do
    sign_in(@admin)

    get moderation_admin_bulletins_path

    assert_response :success
  end

  test "admin can publish bulletin" do
    sign_in(@admin)

    bulletin = bulletins(:under_moderation)

    patch publish_admin_bulletin_path(bulletin)

    assert_redirected_to admin_bulletins_path
    assert bulletin.reload.published?
  end

  test "admin can reject bulletin" do
    sign_in(@admin)

    bulletin = bulletins(:under_moderation)

    patch reject_admin_bulletin_path(bulletin)

    assert_redirected_to admin_bulletins_path
    assert bulletin.reload.rejected?
  end

  test "admin can archive bulletin" do
    sign_in(@admin)

    bulletin = bulletins(:published)

    patch archive_admin_bulletin_path(bulletin)

    assert_redirected_to admin_bulletins_path
    assert bulletin.reload.archived?
  end
end
