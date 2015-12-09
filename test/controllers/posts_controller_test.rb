require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "require user sign_in before viewing posts" do
    get :index
    assert_redirected_to new_user_session_path
  end

end
