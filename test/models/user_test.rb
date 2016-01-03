require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "first user becomes admin" do
    user = User.create(:email => "test1@example.com", :password => "password", :password_confirmation => "password")
    assert user.admin
  end

  test "second user does not become admin" do
    user = User.create(:email => "test1@example.com", :password => "password", :password_confirmation => "password")
    user2 = User.create(:email => "test2@example.com", :password => "password", :password_confirmation => "password")
    assert !user2.admin
  end

  test "user won't be added if username blank" do
    assert_raises ActiveRecord::RecordInvalid do
      user = FactoryGirl.create(:user, name: "")
    end
  end

  test "user won't be added if password blank" do
    assert_raises ActiveRecord::RecordInvalid do
      user = FactoryGirl.create(:user, :password => "")
    end
  end

  test "user won't be added if password less than 8 characters" do
    assert_raises ActiveRecord::RecordInvalid do
      user = FactoryGirl.create(:user, :password => "1234567")
    end
  end

  test "new user defaults to email notifcations for posts" do 
    user = FactoryGirl.create(:user)
    assert user.post_notification
  end

  test "new user defaults to email notifcations for comments" do 
    user = FactoryGirl.create(:user)
    assert user.comment_notification
  end

end
