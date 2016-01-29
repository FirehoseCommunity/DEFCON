require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "defaults opengraph fields to nil when no links in body text" do
    post = FactoryGirl.create(:post)
    assert_nil post.og_url
    assert_nil post.og_title
    assert_nil post.og_description
    assert_nil post.og_image
  end

  test "grabs opengraph data from site url" do
    FakeWeb.register_uri(:any, 'http://www.thefirehoseproject.com', :response => File.join('test/fixtures/og_response.http'))
    # will need to update this in the future if the og metadata tags on the site change
    # currently a helper method tacks on http to the url, maybe test that separately?
    post = FactoryGirl.create(:post, body: "How about www.thefirehoseproject.com?")
    assert_equal "http://www.thefirehoseproject.com", post.og_url
    assert_equal "Mentor Driven Online Coding Bootcamp", post.og_title
    assert_equal "Get 1-on-1 mentor sessions, join an agile team project "\
    "and be ready to switch careers into web development or launch your "\
    "own idea.", post.og_description
    assert_equal "http://www.thefirehoseproject.com/assets/meta-tag-coder.png", post.og_image
  end

  test "send new post notifications" do
    @user1 = FactoryGirl.create(:user, email: "ILoveEmailANDCatsButMostlyCats@test.com")
    perform_enqueued_jobs do
      post = FactoryGirl.create(:post)
      notification = ActionMailer::Base.deliveries.last
      assert_match(/A new post/, notification.subject)
      assert_equal(@user1.email.downcase, notification.to[0].to_s)
    end
  end

  test "notification turned off doesn't enqueue email" do
    assert_no_enqueued_jobs do
      @user = FactoryGirl.create(:user, post_notification: false)
      post = FactoryGirl.create(:post)
    end
  end

  test 'emails are enqueued to be delivered later on post' do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    assert_enqueued_jobs 2 do
      post = FactoryGirl.create(:post)
    end
  end
end
