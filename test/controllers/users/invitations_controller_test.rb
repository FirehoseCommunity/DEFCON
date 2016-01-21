require 'test_helper'

class Admin::Users::InvitationsControllerTest < ActionController::TestCase
  
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "admin can access invite page" do
    user = User.create(:email => "example1@example.com", :password => "password", :password_confirmation => "password", :admin => true)
    sign_in user
    get :new
    assert_response :success
  end

  test "non-admin user cannot access invite page" do
    user = User.create(:email => "example@example.com", :password => "password", :password_confirmation => "password", :admin => false)
    sign_in user
    get :new
    assert_response :unauthorized
  end

  test "admin can invite user" do
    admin = User.create(:email => "example@example.com", :password => "password", :password_confirmation => "password", :admin => true)
    sign_in admin
    post :create
    assert_response :success
  end
end
