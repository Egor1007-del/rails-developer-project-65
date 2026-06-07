require "test_helper"

class BulletinTest < ActiveSupport::TestCase
  test "requires image" do
    bulletin = Bulletin.new(
      title: "Title",
      description: "Description",
      category: categories(:one),
      user: users(:regular)
    )

    assert_not bulletin.valid?
    assert bulletin.errors.added?(:image, :blank)
  end

  test "allows moderation from draft" do
    bulletin = bulletins(:draft)

    assert bulletin.may_to_moderate?
  end

  test "does not allow publishing from draft" do
    bulletin = bulletins(:draft)

    assert_not bulletin.may_publish?
  end
end
