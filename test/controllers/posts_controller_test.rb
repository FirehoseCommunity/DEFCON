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

  test "send new post notification" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post = FactoryGirl.create(:post)
    end
    notification = ActionMailer::Base.deliveries.last
    assert_match(/A new post/, notification.subject)
  end

end
