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
end
