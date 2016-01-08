require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  test "will allow admin to view admin pages" do
    admin = FactoryGirl.create(:user, admin: true)
    assert admin.admin?
    sign_in admin
    get :index
    assert_response :success
  end

  test "will not allow non-admin to view admin pages" do
    user = FactoryGirl.create(:user)
    refute user.admin?
    sign_in user
    get :index
    assert_redirected_to root_path
  end

  test "will allow admin to promote user" do
    user = FactoryGirl.create(:user)
    refute user.admin?
    admin = FactoryGirl.create(:user, admin: true)
    sign_in admin
    put :update, id: user.id, user: { admin: true }
    user.reload
    assert user.admin?
    assert_redirected_to user_path
  end

  test "will not allow non-admin to promote user" do
    user = FactoryGirl.create(:user)
    refute user.admin?
    sign_in user
    put :update, id: user.id, user: { admin: true }
    refute user.admin?
    assert_redirected_to root_path
  end
end
