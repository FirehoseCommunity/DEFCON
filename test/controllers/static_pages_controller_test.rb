require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get index" do
    user = FactoryGirl.create(:user)
    sign_in user
    get :index
    assert_response :success
  end

end
