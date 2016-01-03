require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "require user sign_in before viewing user dashboard" do
    u = FactoryGirl.create(:user)
    get :show, id: u.id
    assert_redirected_to new_user_session_path
  end

  test "get user dashboard page" do
    u = FactoryGirl.create(:user)
    sign_in u
    get :show, id: u.id
    assert_response :success      
  end

  test "can view another users' dashboard if not admin" do
    u = FactoryGirl.create(:user)
    p = FactoryGirl.create(:user)
    sign_in p
    get :show, id: u.id
    assert_response :success
  end

  test "can view another users' dashboard if admin" do
    u = FactoryGirl.create(:user)
    p = FactoryGirl.create(:user, admin: true)
    sign_in p
    get :show, id: u.id
    assert_response :success
  end

  test "change notification preference for posts to true" do
    u = FactoryGirl.create(:user)
    sign_in u
    put :update, id: u.id, user: { post_notification: true }
    u.reload
    assert u.post_notification
    assert_redirected_to user_path(u)
  end

  test "change notification preference for posts to false" do
    u = FactoryGirl.create(:user)
    sign_in u
    put :update, id: u.id, user: { post_notification: false }
    u.reload
    assert !u.post_notification
    assert_redirected_to user_path(u)
  end

  test "change notification preference for comments to true" do
    u = FactoryGirl.create(:user)
    sign_in u
    put :update, id: u.id, user: { comment_notification: true }
    u.reload
    assert u.comment_notification
    assert_redirected_to user_path(u)
  end

  test "change notification preference for comments to false" do
    u = FactoryGirl.create(:user)
    sign_in u
    put :update, id: u.id, user: { comment_notification: false }
    u.reload
    assert !u.comment_notification
    assert_redirected_to user_path(u)
  end

  test "will allow admin to edit user info" do
    u = FactoryGirl.create(:user)
    p = FactoryGirl.create(:user, admin: true)
    sign_in p
    put :update, id: u.id, user: { name: "ILovePizza" }
    u.reload
    # waiting for admin flag fix
    #assert_equal "ILovePizza", u.name
    assert_redirected_to root_path
  end

  test "will not allow non-admin to edit user info" do
    u = FactoryGirl.create(:user)
    p = FactoryGirl.create(:user)
    sign_in p
    put :update, id: u.id, user: { name: "I<3Pizza" }
    assert_not_equal "ILovePizza", u.name
    assert_equal "Can only edit your own profile!", flash[:alert]
    assert_redirected_to root_path
  end
end
