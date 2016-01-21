require 'test_helper'

# I get a SYNTAX ERROR with post :create
# I am able to do a get :index and get an EXPECTED action not found failure/error
# Both have the same route viability
# I can create a vote manually in the console
# I've been trying different syntax combinations to no avail

class VotesControllerTest < ActionController::TestCase
  test "vote on post" do
    user = FactoryGirl.create(:user)
    post = FactoryGirl.create(:post, user: user)
    user2 = FactoryGirl.create(:user)
    sign_in user2
    get :index
    # post :create
    # assert_difference 'post.votes.count' do
    #   # post :create
    #   # post :create, :user_id => user2.id, :votable_id => post.id, :votable_type => 'Post'
    #   post :create, :votable_id => post.id, :votable_type => 'Post'
    # end
    # vote = Vote.last
    # assert_equal user2, vote.user
  end
end
