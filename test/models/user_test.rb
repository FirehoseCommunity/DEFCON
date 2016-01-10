require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "admin promotion" do
    user = User.create(:email => "test1@example.com", :password => "password", :password_confirmation => "password")
    user2 = User.create(:email => "test2@example.com", :password => "password", :password_confirmation => "password", :admin => true)
    assert !user.admin
    assert user2.admin
    user2.promote(user)
    assert user.admin
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

  test "will pull list of users who want to be notified of posts" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    user3 = FactoryGirl.create(:user, post_notification: false)
    assert_equal 2, User.all.users_to_notify.count
  end

  test "will find user when searching" do
    user = FactoryGirl.create(:user)
    results = User.search("Rob")
    assert_equal "Robert Sapunarich", results.first.name
  end

  test "will not find user when searching for non-existant user name or email" do
    user = FactoryGirl.create(:user)
    results = User.search("fail")
    assert_nil results.first
  end
end
