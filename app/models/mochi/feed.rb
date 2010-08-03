module Mochi

  class Feed
    include HappyMapper
    tag 'feed'

    element :id, String
    element :title, String
    element :subtitle, String
    element :icon, String
    element :updated, Time

    has_many :games, "Mochi::Game", :tag => "entry"
    has_one :link, "Mochi::Link"
    has_one :author, "Mochi::Author"
    
    def url
      return nil unless link
      self.link.url
    end

    def parse(*args)
      super(args.first, :single => true)
    end

  end

  class Link
    include HappyMapper
    tag 'link'

    attribute :url, String, :tag => "href"
    attribute :rel, String
  end

  class Author
    include HappyMapper
    tag 'author'

    element :email, String
    element :name, String
    element :url, String, :tag => "uri"

  end

end

