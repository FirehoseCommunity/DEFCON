class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  def extract_first_url_from_body
    url_list = extract_first_url_from_string(body)
    return url_list[0] if url_list.present? 
  end

  private
    def extract_urls_from_string(input)
      # borrowed from https://github.com/matthewrudy/regexpert/blob/master/lib/regexpert.rb
      url_regex = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
      input.scan(url_regex)[0]
    end
end
