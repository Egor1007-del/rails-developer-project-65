require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "home shows only published bulletins" do
    get root_path

    assert_response :success

    assert_select "a", text: bulletins(:published).title
    assert_select "a", text: bulletins(:draft).title, count: 0
    assert_select "a", text: bulletins(:under_moderation).title, count: 0
    assert_select "a", text: bulletins(:archived).title, count: 0
  end
end
