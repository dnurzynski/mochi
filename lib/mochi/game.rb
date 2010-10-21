module Mochi

  NAMESPACES = {
    :media   => 'http://search.yahoo.com/mrss/',
    :summary => 'http://www.w3.org/1999/xhtml'
  }

  class Game
    include HappyMapper
    tag 'entry'

    attr_accessor :summary

    element :id, String
    element :title, String
    element :description, String, :namespace => NAMESPACES[:media]
    element :updated, Time
    element :published, Time
    element :thumbnail, String, :namespace => NAMESPACES[:media], :attributes => { :height => Integer, :width => Integer, :url => String }
    element :keywords, String, :namespace => NAMESPACES[:media]
    element :player, String, :namespace => NAMESPACES[:media], :attributes => {:height => Integer, :width => Integer, :url => String}
    element :category, String

    has_one  :author, 'Mochi::Author'
    has_many :links, 'Mochi::Link'
    has_many :categories, 'Mochi::GameCategory'
    has_many :details, 'Mochi::GameDetail'

    after_parse(&:format_keywords)
    after_parse(&:parse_categories)
    after_parse(&:create_summary_hash)

    protected

    def format_keywords
      self.keywords = keywords.nil? ? [] : keywords.split(',').map(&:strip).compact
    end

    def parse_categories
      self.categories = categories.map{|category| category.term}.compact
    end

    def create_summary_hash
      self.summary = details.map(&:to_hash).inject({}){|sum, detail| sum.merge detail}
    end

  end

  class GameCategory
    include HappyMapper
    tag 'category'

    attribute :term, String
  end

  class GameDetail
    include HappyMapper
    tag 'dd'
    namespace NAMESPACES[:summary]
    content :value

    element :embed, String, :tag => 'code'
    attribute :detail_type, String, :tag => "class"

    after_parse(&:check_embed)

    def to_hash
      { detail_type.to_sym => value } 
    end

    protected

    def check_embed
     self.detail_type, self.value = 'embed', embed if detail_type == "" && embed != ""
    end

  end

end

