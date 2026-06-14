require "test_helper"

class BulletinTest < ActiveSupport::TestCase
  test "requires image" do
    bulletin = build_bulletin

    assert_not bulletin.valid?
    assert_includes bulletin.errors.details[:image].pluck(:error), :blank
  end

  test "requires image with allowed content type" do
    bulletin = build_bulletin
    bulletin.image.attach(io: StringIO.new("plain text"), filename: "image.txt", content_type: "text/plain")

    assert_not bulletin.valid?
    assert_includes bulletin.errors.details[:image].pluck(:error), :content_type_invalid
  end

  test "requires image up to 5 megabytes" do
    bulletin = build_bulletin
    bulletin.image.attach(io: StringIO.new("x" * 6.megabytes), filename: "image.png", content_type: "image/png")

    assert_not bulletin.valid?
    assert_includes bulletin.errors.details[:image].pluck(:error), :file_size_not_less_than_or_equal_to
  end

  test "allows moderation from draft" do
    bulletin = bulletins(:draft)

    assert bulletin.may_to_moderate?
  end

  test "does not allow publishing from draft" do
    bulletin = bulletins(:draft)

    assert_not bulletin.may_publish?
  end

  private

  def build_bulletin
    Bulletin.new(
      title: "Title",
      description: "Description",
      category: categories(:one),
      user: users(:regular)
    )
  end
end
