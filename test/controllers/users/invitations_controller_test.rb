require 'test_helper'

class Users::InvitationsControllerTest < ActionController::TestCase
  test "admin can access invite page" do    
    user = User.create(:email => "example@example.com", :password => "password", :password_confirmation => "password", :admin => true)
    sign_in user
    get :new
    assert_response :success
  end
end
