require "test_helper"

class BulletinsTest < ActionDispatch::IntegrationTest
  include ActionDispatch::TestProcess::FixtureFile
  setup do
    @user = users(:regular)
    @category = categories(:one)
  end

  test "signed in user can create bulletin" do
    sign_in(@user)

    image = fixture_file_upload(Rails.root.join("test/fixtures/files/test.png"), "image/png")

    assert_difference("Bulletin.count") do
      post bulletins_path, params: {
        bulletin: {
          title: "New bulletin",
          description: "New bulletin description",
          category_id: @category.id,
          image: image
        }
      }
    end

    bulletin = Bulletin.last

    assert_redirected_to profile_path
    assert_equal @user, bulletin.user
    assert_equal "draft", bulletin.state
    assert bulletin.image.attached?
  end

  test "guest cannot create bulletin" do
    image = fixture_file_upload(Rails.root.join("test/fixtures/files/test.png"), "image/png")
    assert_no_difference("Bulletin.count") do
      post bulletins_path, params: {
        bulletin: {
          title: "New bulletin",
          description: "New bulletin description",
          category_id: @category.id,
          image: image
        }
      }
    end

    assert_redirected_to root_path
  end

  test "signed in user cannot create bulletin without category" do
    sign_in(@user)

    image = fixture_file_upload(Rails.root.join("test/fixtures/files/test.png"), "image/png")

    assert_no_difference("Bulletin.count") do
      post bulletins_path, params: {
        bulletin: {
          title: "New bulletin",
          description: "New bulletin description",
          image: image
        }
      }
    end

    assert_response :unprocessable_entity
    assert_match "должна быть выбрана", response.body
  end

  test "bulletin publication workflow" do
    bulletin = bulletins(:draft)

    sign_in(users(:regular))

    patch to_moderate_bulletin_path(bulletin)

    assert bulletin.reload.under_moderation?

    sign_in(users(:admin))

    patch publish_admin_bulletin_path(bulletin)

    assert bulletin.reload.published?

    get root_path

    assert_match bulletin.title, response.body
  end

  test "guest can view published bulletin" do
    bulletin = bulletins(:published)

    get bulletin_path(bulletin)

    assert_response :success
    assert_match bulletin.title, response.body
  end

  test "guest cannot view draft bulletin" do
    bulletin = bulletins(:draft)

    get bulletin_path(bulletin)

    assert_redirected_to root_path
  end

  test "owner can view own draft bulletin" do
    sign_in(users(:regular))

    bulletin = bulletins(:draft)

    get bulletin_path(bulletin)

    assert_response :success
    assert_match bulletin.title, response.body
  end
  test "owner can open edit page" do
    sign_in(users(:regular))

    bulletin = bulletins(:draft)

    get edit_bulletin_path(bulletin)

    assert_response :success
  end

  test "guest cannot open edit page" do
    bulletin = bulletins(:draft)

    get edit_bulletin_path(bulletin)

    assert_redirected_to root_path
  end
  test "owner can update bulletin" do
    sign_in(users(:regular))

    bulletin = bulletins(:draft)

    image = fixture_file_upload(Rails.root.join("test/fixtures/files/test.png"), "image/png")

    patch bulletin_path(bulletin), params: {
      bulletin: {
        title: "Updated title",
        description: bulletin.description,
        category_id: bulletin.category_id,
        image: image
      }
    }

    assert_redirected_to profile_path
    assert_equal "Updated title", bulletin.reload.title
  end

  test "owner cannot edit published bulletin" do
    sign_in(users(:admin))

    bulletin = bulletins(:published)

    get edit_bulletin_path(bulletin)

    assert_redirected_to profile_path
  end

  test "owner cannot update published bulletin" do
    sign_in(users(:admin))

    bulletin = bulletins(:published)

    patch bulletin_path(bulletin), params: {
      bulletin: {
        title: "Changed published title",
        description: bulletin.description,
        category_id: bulletin.category_id
      }
    }

    assert_redirected_to profile_path
    assert_not_equal "Changed published title", bulletin.reload.title
  end

  test "owner cannot update bulletin with invalid data" do
    sign_in(users(:regular))

    bulletin = bulletins(:draft)

    patch bulletin_path(bulletin), params: {
      bulletin: {
        title: "",
        description: bulletin.description,
        category_id: bulletin.category_id
      }
    }

    assert_response :unprocessable_entity
    assert_not_equal "", bulletin.reload.title
  end
  test "user cannot edit another user's bulletin" do
    sign_in(users(:regular))

    bulletin = bulletins(:other_user_draft)

    get edit_bulletin_path(bulletin)

    assert_response :not_found
  end

  test "invalid moderation transition redirects without changing state" do
    sign_in(users(:regular))

    bulletin = bulletins(:under_moderation)

    patch to_moderate_bulletin_path(bulletin)

    assert_redirected_to profile_path
    assert bulletin.reload.under_moderation?
  end
end
