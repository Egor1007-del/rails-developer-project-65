require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "normalizes name before validation" do
    category = Category.new(name: "  Toys  ")

    category.valid?

    assert_equal "Toys", category.name
  end

  test "validates name uniqueness case insensitively" do
    category = Category.new(name: categories(:one).name.upcase)

    assert_not category.valid?
    assert category.errors.added?(:name, :taken, value: category.name)
  end
end
