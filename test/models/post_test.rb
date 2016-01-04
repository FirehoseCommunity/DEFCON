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
end
