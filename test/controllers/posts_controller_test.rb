require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  test "require user sign_in before viewing posts" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "get index page" do
    u = FactoryGirl.create(:user)
    sign_in u
    get :index
    assert_response :success
  end

  test "make a post" do
    u = FactoryGirl.create(:user)
    sign_in u

    assert_difference 'Post.count' do
      post :create, {:post => {
        :title => 'the things',
        :body => "do all of them",
        }
      }
    end
    assert_redirected_to posts_path
  end

  test "show post page" do
    u = FactoryGirl.create(:user)
    sign_in u
    p = FactoryGirl.create(:post)
    get :show, id: p.id
    assert_response :success
  end

  test "user upvotes a post" do
    u = FactoryGirl.create(:user)
    sign_in u
    p = FactoryGirl.create(:post)
    put :upvote, id: p.id
    assert_redirected_to posts_path
  end

  test "user un-upvotes a post" do
    u = FactoryGirl.create(:user)
    sign_in u
    p = FactoryGirl.create(:post)
    delete :unvote, id: p.id
    assert_redirected_to posts_path
  end
end
