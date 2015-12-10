require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "first user becomes admin" do
    user = User.create(:email => "test1@example.com", :password => "password", :password_confirmation => "password")
    assert_equal true, user.admin
  end

  test "second user does not become admin" do
    user = User.create(:email => "test1@example.com", :password => "password", :password_confirmation => "password")
    user2 = User.create(:email => "test2@example.com", :password => "password", :password_confirmation => "password")
    assert_equal false, user2.admin
  end

end
