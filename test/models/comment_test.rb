require 'test_helper'

class CommentTest < ActiveSupport::TestCase
   test "comment_on_post" do 
     comment = Comment.create(:user_id => 1, :message => 'Tacocats and Stackcats')
    expected = 1  
     actual = comment.comment_on_post
  # comment = FactoryGirl.create(:comment, :author => 'Cecelia')
  #   expected = 'KM#' + quote.id.to_s
  #   actual = quote.unique_tag
    assert_equal expected, actual
    
  end

end
