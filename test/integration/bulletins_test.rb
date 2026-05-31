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
end
