require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email before validation" do
    user = User.new(name: "User", email: " USER@Example.COM ")

    user.valid?

    assert_equal "user@example.com", user.email
  end

  test "validates email uniqueness case insensitively" do
    user = User.new(name: "User", email: users(:regular).email.upcase)

    assert_not user.valid?
    assert user.errors.added?(:email, :taken, value: user.email)
  end
end
