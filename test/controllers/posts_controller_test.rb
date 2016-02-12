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

  test 'admin can destroy others posts' do
    user = FactoryGirl.create(:user, admin: false)
    admin = FactoryGirl.create(:user, admin: true)
    post = FactoryGirl.create(:post, user_id: user.id)
    sign_in admin

    delete :destroy, id: post.id

    assert_response :success
  end

  test 'user cant destroy others posts' do
    user = FactoryGirl.create(:user, admin: false)
    user2 = FactoryGirl.create(:user, admin: false)
    post = FactoryGirl.create(:post, user_id: user2.id)
    sign_in user

    delete :destroy, id: post.id

    assert_response :unauthorized
  end
    
  test 'user can destroy their own posts' do
    user = FactoryGirl.create(:user, admin: false)
    post = FactoryGirl.create(:post, user_id: user.id)
    sign_in user

    delete :destroy, id: post.id

    assert_response :success
  end


end
