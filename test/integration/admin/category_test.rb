require "test_helper"

class AdminCategoriesTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @user = users(:regular)
    @category = categories(:one)
  end

  test "admin can view categories" do
    sign_in(@admin)

    get admin_categories_path

    assert_response :success
    assert_select "h1", I18n.t("web.admin.categories.index.title")
  end

  test "regular user cannot view categories" do
    sign_in(@user)

    get admin_categories_path

    assert_redirected_to root_path
  end

  test "guest cannot view categories" do
    get admin_categories_path

    assert_redirected_to root_path
  end

  test "admin can create category" do
    sign_in(@admin)

    assert_difference("Category.count") do
      post admin_categories_path, params: {
        category: {
          name: "New category"
        }
      }
    end

    assert_redirected_to admin_categories_path
    assert_equal "New category", Category.last.name
  end

  test "admin cannot create invalid category" do
    sign_in(@admin)

    assert_no_difference("Category.count") do
      post admin_categories_path, params: {
        category: {
          name: ""
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-danger"
  end

  test "admin can update category" do
    sign_in(@admin)

    patch admin_category_path(@category), params: {
      category: {
        name: "Updated category"
      }
    }

    assert_redirected_to admin_categories_path
    assert_equal "Updated category", @category.reload.name
  end

  test "admin cannot update category with invalid data" do
    sign_in(@admin)

    patch admin_category_path(@category), params: {
      category: {
        name: ""
      }
    }

    assert_response :unprocessable_entity
    assert_not_equal "", @category.reload.name
    assert_select ".alert-danger"
  end

  test "admin can destroy category" do
    sign_in(@admin)

    @category = categories(:empty)

    assert_difference("Category.count", -1) do
      delete admin_category_path(@category)
    end

    assert_redirected_to admin_categories_path
  end
end
