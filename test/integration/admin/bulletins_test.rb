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

  test "admin cannot publish bulletin from invalid state" do
    sign_in(@admin)

    bulletin = bulletins(:published)

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

  test "admin searches bulletins by title" do
    sign_in(users(:admin))

    get admin_bulletins_path, params: {
      q: {
        title_cont: bulletins(:published).title
      }
    }

    assert_response :success
    assert_match bulletins(:published).title, response.body
  end

  test "admin filters bulletins by category" do
    sign_in(users(:admin))

    get admin_bulletins_path, params: {
      q: {
        category_id_eq: categories(:one).id
      }
    }

    assert_response :success
  end

  test "admin bulletins supports pagination" do
    sign_in(users(:admin))

    get admin_bulletins_path, params: { page: 2 }

    assert_response :success
  end

  test "admin searches moderation bulletins by title" do
    sign_in(users(:admin))

    get moderation_admin_bulletins_path, params: {
      q: {
        title_cont: bulletins(:under_moderation).title
      }
    }

    assert_response :success
    assert_match bulletins(:under_moderation).title, response.body
  end

  test "admin moderation supports pagination" do
    sign_in(users(:admin))

    get moderation_admin_bulletins_path, params: { page: 2 }

    assert_response :success
  end
end
