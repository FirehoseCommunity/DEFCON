require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test "create comment requires logged in" do 
    post :create, :post_id => 'Tacocats'
    assert_redirected_to new_user_session_path
  end
  
  test "create comment success" do
    u = FactoryGirl.create(:user)
    sign_in u
    pst = FactoryGirl.create(:post)
    assert_difference 'pst.comments.count' do
      post :create, :post_id => pst.id, :comment => {
        :message => 'testing tests'
      }
    end
    assert_redirected_to post_path(pst)
    comment = Comment.last
    assert_equal u, comment.user
  end
  
  test "create comment needs a valid post_id" do
    u = FactoryGirl.create(:user)
    sign_in u
    post :create, :post_id => 'omg'
    assert_response :not_found
  end
  
   test "destroy requires you to be logged in" do
    comment = FactoryGirl.create(:comment)
    delete :destroy, :id => comment.id
    assert_redirected_to new_user_session_path
  end
  
    test "author can destroy comment" do
    u = FactoryGirl.create(:user)
    sign_in u
    comment = FactoryGirl.create(:comment, :user => u)
    delete :destroy, :id => comment.id
    assert_redirected_to post_path(comment.post)
    assert_nil Comment.find_by_id(comment.id)
  end
  
  test "destroy not logged in" do
   comment = FactoryGirl.create(:comment)
    assert_no_difference 'Comment.count' do
      delete :destroy, :id => comment.id
    end
    assert_redirected_to new_user_session_path
  end
  
test "random person cannot destroy a comment" do
    u = FactoryGirl.create(:user)
    sign_in u

    comment = FactoryGirl.create(:comment)
    delete :destroy, :id => comment.id
    assert_response :forbidden

    assert Comment.find_by_id(comment.id).present?
  end
  
test "destroy not found" do
    sign_in FactoryGirl.create(:user)
    delete :destroy, :id => 'omg'
    assert_response :not_found
  end
  
test "edit not logged in" do
    comment = FactoryGirl.create(:comment)
    get :edit, :id => comment.id
    assert_redirected_to new_user_session_path
  end
  
  test "edit logged in as a different user" do
    user = FactoryGirl.create(:user)
    sign_in user
    comment = FactoryGirl.create(:comment)
    get :edit, :id => comment.id
    assert_response :unauthorized
  end
  
  test "edit found" do
    comment = FactoryGirl.create(:comment)
    sign_in comment.user

    get :edit, :id => comment.id
    assert_response :success
  end
  
  test "edit not found" do
    u = FactoryGirl.create(:user)
    sign_in u
    put :edit, :id => 'tacocat'
    assert_response :not_found
  end
  
  test "update not logged in" do
    comment = FactoryGirl.create(:comment, :message => 'stackcats')
    put :update, :id => comment.id, :comment => {:message => 'tacocat'}
    assert_redirected_to new_user_session_path
  end
  
  test "update as a different user" do
    sign_in FactoryGirl.create(:user)
    comment = FactoryGirl.create(:comment, :message => 'stackcats')
    put :update, :id => comment.id, :comment => {:message => 'tacocat'}
    assert_response :unauthorized
  end
  
  test "update success" do
    comment = FactoryGirl.create(:comment, :message => 'stackcats')
    sign_in comment.user
    put :update, :id => comment.id, :comment => {:message => 'tacocat'}
    assert_equal 'tacocat', comment.reload.message
    assert_redirected_to post_path(comment.post)
  end
  
  test "update not found" do
    u = FactoryGirl.create(:user)
    sign_in u
    put :update, :id => 'tacocat', :comment => {:message => 'tacocat'}
    assert_response :not_found
  end

  test "send new comment notifications to post owner" do
    post = FactoryGirl.create(:post)
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user, post_interaction_notification: false)
    comment2 = FactoryGirl.create(:comment, post: post, user: user2)
    clear_enqueued_jobs
    sign_in user1
    perform_enqueued_jobs do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        # user who makes comment doesn't get notified
        post(:create, post_id: post.id, comment: { message: 'testing tests' })
        notification = ActionMailer::Base.deliveries.last
        assert_match(/A new comment/, notification.subject)
        assert_equal(post.user.email.downcase, notification.to[0].to_s)
      end
    end
  end

  test "send new comment notifications to post interactor" do
    poster = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, user: poster)
    user1 = FactoryGirl.create(:user)
    comment1 = FactoryGirl.create(:comment, post: post, user: user1)
    user2 = FactoryGirl.create(:user, post_interaction_notification: false)
    comment2 = FactoryGirl.create(:comment, post: post, user: user2)
    clear_enqueued_jobs
    sign_in poster
    perform_enqueued_jobs do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        # user who makes comment doesn't get notified
        post(:create, post_id: post.id, comment: { message: 'testing tests' })
        notification = ActionMailer::Base.deliveries.last
        assert_match(/A new comment/, notification.subject)
        assert_equal(user1.email.downcase, notification.to[0].to_s)
      end
    end
  end

  test "notification turned off for post owner doesn't enqueue email" do
    post = FactoryGirl.create(:post)
    post.user.comment_notification = false
    post.user.save(:validate => false)
    u = FactoryGirl.create(:user)
    sign_in u
    assert_no_enqueued_jobs do
      post(:create, post_id: post.id, comment: { message: 'testing tests' })
    end
  end

  test "notification turned off for post commenter doesn't enqueue email" do
    post = FactoryGirl.create(:post)
    u = FactoryGirl.create(:user, post_interaction_notification: false)
    comment = FactoryGirl.create(:comment, post: post, user: u)
    clear_enqueued_jobs
    sign_in post.user
    assert_no_enqueued_jobs do
      post(:create, post_id: post.id, comment: { message: 'testing tests' })
    end
  end

  test 'emails are enqueued to be delivered later on comment' do
    post = FactoryGirl.create(:post)
    user1 = FactoryGirl.create(:user)
    comment1 = FactoryGirl.create(:comment, post: post, user: user1)
    # now user1 should be notified of new comments on this post
    clear_enqueued_jobs # get rid of previously queued jobs from post/comment
    user2 = FactoryGirl.create(:user)
    sign_in user2
    assert_enqueued_jobs 2 do
      post(:create, post_id: post.id, comment: { message: 'testing tests' })
      # should queue to notify user1 and the post creator
    end
  end
  
end

