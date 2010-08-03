module Mochi

  class Game
    include HappyMapper
    tag 'entry'

    element :id, String
    element :title, String
    element :description, String, :tag => 'description', :namespace => 'media'
    element :updated, Time
    element :published, Time

    has_one :author, Mochi::Author
    has_many :links, 'Mochi::Link'
#    has_many :dd, String
  end

end
