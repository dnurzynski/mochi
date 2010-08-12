module Mochi

  class Feed
    include HappyMapper
    tag 'feed'

    attr_accessor :url

    element :id, String
    element :title, String
    element :subtitle, String
    element :icon, String
    element :updated, Time

    has_many :games, "Mochi::Game", :tag => "entry"
    has_one :link, "Mochi::Link"
    has_one :author, "Mochi::Author"

    after_parse(&:set_url)

    protected

    def set_url
      self.url = self.link.url if self.link.url
    end

  end

  class Link
    include HappyMapper
    tag 'link'

    attribute :url, String, :tag => "href"
    attribute :rel, String
    attribute :file_type, String, :tag => "type"
  end

  class Author
    include HappyMapper
    tag 'author'

    element :email, String
    element :name, String
    element :url, String, :tag => "uri"

  end

end
