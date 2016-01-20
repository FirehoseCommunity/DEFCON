require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  def setup
    Sidekiq::Testing.fake!
  end

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

  test "create new post notifications" do
    Sidekiq::Testing.inline!
    @user1 = FactoryGirl.create(:user, email: "ILoveEmailANDCatsButMostlyCats@test.com")
    post = FactoryGirl.create(:post)
    notification = ActionMailer::Base.deliveries.last
    assert_match(/A new post/, notification.subject)
    assert_equal(@user1.email.downcase, notification.to[0].to_s)
  end

  test "notification turned off doesn't enqueue email" do
    assert_no_difference 'Sidekiq::Extensions::DelayedMailer.jobs.size' do
      @user = FactoryGirl.create(:user, post_notification: false)
      post = FactoryGirl.create(:post)
    end
  end

  test 'emails are enqueued to be delivered later on post' do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    assert_difference 'Sidekiq::Extensions::DelayedMailer.jobs.size', +2 do
      post = FactoryGirl.create(:post)
    end
  end
end
