require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  test "vote on post" do
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, user: user)
    user2 = FactoryGirl.create(:user)
    sign_in user2
    assert_difference 'post.votes.count' do
      post :create, :user_id => user2.id, :votable_id => post.id, :votable_type => 'Post'
    end
    vote = Vote.last
    assert_equal user2, vote.user
  end
end