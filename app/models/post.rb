class Post < ActiveRecord::Base
  include Twitter::Extractor
  belongs_to :user
  has_many :comments
  after_save :parse_og_data_from_first_link # any time we create/update a post, re-grab og data
  after_create :new_post_notification


  private
    def parse_og_data_from_first_link
      # this gets the Open Graph metadata from the first link in the post body text
      # currently it gets displayed in the bottom of the post
      url_array = extract_urls_from_body
      unless url_array.empty? # did it find a url in the post body?
        first_url = url_array[0]
        og = OpenGraph.new(add_url_protocol(first_url)) # new OG parser instance
        # grabs first image from meta tags
        update_columns(og_title: og.title, og_description: og.description, og_url: og.url, og_image: og.images[0])
      end
    end

    def extract_urls_from_body
      # uses twitter-text gem to pull out an array of urls
      extract_urls(body)
    end

    def add_url_protocol(url)
      # adds http or https to links if they are not present so OG parser works
      return "http://#{url}" unless url[/^https?:\/\//] || url[/^http?:\/\//]
      url
    end

    def new_post_notification
      @recipients = User.where("post_notification = ? AND email != ?", true, self.user.email)
      unless @recipients.empty?
        @recipients.each do |recipient|
          NotificationMailer.send_notification(self, recipient).deliver
        end
      end
    end
end
