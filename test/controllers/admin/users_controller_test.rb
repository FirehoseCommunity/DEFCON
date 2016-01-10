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

  test "search will return user with valid search term" do
    admin = FactoryGirl.create(:user, admin: true)
    user = FactoryGirl.create(:user, name: "Pizza the Hutt")
    sign_in admin
    # search for name
    get :index, term: admin.name, format: :json
    body = JSON.parse(response.body)
    # should currently be two users with this factory name
    assert_equal 1, body.size
    assert_equal body.first["name"], admin.name
  end

  test "search will return multiple users that match search term" do
    admin = FactoryGirl.create(:user, admin: true) #default name Robert
    user = FactoryGirl.create(:user, name: "Robin Hood")
    sign_in admin
    # search for name
    get :index, term: "Rob", format: :json
    body = JSON.parse(response.body)
    # should have two users that match
    assert_equal 2, body.size
    assert_match (/Rob/), body.first["name"]
    assert_match (/Rob/), body.last["name"]
  end

  test "search will return no users with invalid search term" do
    admin = FactoryGirl.create(:user, admin: true)
    user = FactoryGirl.create(:user)
    sign_in admin
    # search for bad term
    get :index, term: "lolCatz", format: :json
    assert_empty JSON.parse(response.body)
  end
end
