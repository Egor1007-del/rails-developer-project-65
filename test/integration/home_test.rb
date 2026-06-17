require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "github callback without email redirects with alert" do
    sign_in_with_github(email: "")

    assert_redirected_to root_path
  end

  test "github callback finds existing user case insensitively" do
    assert_no_difference("User.count") do
      sign_in_with_github(email: users(:regular).email.upcase)
    end

    assert_redirected_to root_path
  end

  test "github callback without name does not guess name from email" do
    assert_no_difference("User.count") do
      sign_in_with_github(email: "new-user@example.com", name: "")
    end

    assert_redirected_to root_path
  end

  test "github callback without name keeps existing user name" do
    user = users(:admin)

    assert_no_changes -> { user.reload.name } do
      sign_in_with_github(email: user.email, name: "")
    end

    assert_redirected_to root_path
  end

  test "home shows only published bulletins" do
    get root_path

    assert_response :success

    assert_select "a", text: bulletins(:published).title
    assert_select "a", text: bulletins(:draft).title, count: 0
    assert_select "a", text: bulletins(:under_moderation).title, count: 0
    assert_select "a", text: bulletins(:archived).title, count: 0
  end
  test "home searches published bulletins by title" do
    get root_path, params: {
      q: {
        title_cont: bulletins(:published).title
      }
    }

    assert_response :success
    assert_match bulletins(:published).title, response.body
    assert_no_match bulletins(:draft).title, response.body
  end

  test "home filters published bulletins by category" do
    category = categories(:one)

    get root_path, params: {
      q: {
        category_id_eq: category.id
      }
    }

    assert_response :success

    Bulletin.published.where(category: category).each do |bulletin|
      assert_match bulletin.title, response.body
    end
  end

  test "home does not show non published bulletins" do
    get root_path

    assert_response :success
    assert_match bulletins(:published).title, response.body
    assert_no_match bulletins(:draft).title, response.body
    assert_no_match bulletins(:under_moderation).title, response.body
    assert_no_match bulletins(:archived).title, response.body
  end

  test "home paginates published bulletins" do
    category = categories(:one)
    user = users(:regular)
    image = fixture_file_upload(Rails.root.join("test/fixtures/files/test.png"), "image/png")

    13.times do |i|
      Bulletin.create!(
        title: "Published bulletin #{i}",
        description: "Description #{i}",
        category: category,
        user: user,
        state: "published",
        image: image
      )
    end

    get root_path

    assert_response :success
    assert_select ".pagination"
  end
end
