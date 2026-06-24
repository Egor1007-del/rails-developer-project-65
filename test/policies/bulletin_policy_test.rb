require "test_helper"

class BulletinPolicyTest < ActiveSupport::TestCase
  test "guest can view published bulletin" do
    assert BulletinPolicy.new(nil, bulletins(:published)).show?
  end

  test "guest cannot view draft bulletin" do
    assert_not BulletinPolicy.new(nil, bulletins(:draft)).show?
  end

  test "owner can view own draft bulletin" do
    assert BulletinPolicy.new(users(:regular), bulletins(:draft)).show?
  end

  test "admin can view draft bulletin" do
    assert BulletinPolicy.new(users(:admin), bulletins(:draft)).show?
  end

  test "owner can update draft bulletin" do
    assert BulletinPolicy.new(users(:regular), bulletins(:draft)).update?
  end

  test "owner can update rejected bulletin" do
    assert BulletinPolicy.new(users(:admin), bulletins(:rejected)).update?
  end

  test "owner cannot update published bulletin" do
    assert_not BulletinPolicy.new(users(:admin), bulletins(:published)).update?
  end

  test "user cannot update another user's bulletin" do
    assert_not BulletinPolicy.new(users(:regular), bulletins(:other_user_draft)).update?
  end

  test "guest cannot update bulletin" do
    assert_not BulletinPolicy.new(nil, bulletins(:draft)).update?
  end
end
