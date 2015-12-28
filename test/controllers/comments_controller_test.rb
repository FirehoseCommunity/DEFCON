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
  
  # test "create comment needs a valid post_id" do
  #   u = FactoryGirl.create(:user)
  #   sign_in u
  #   post :create, :post_id => 'omg'
  #   assert_response :not_found
  # end
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

end

