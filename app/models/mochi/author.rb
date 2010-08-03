module Mochi

  class Author
    include HappyMapper
    tag 'author'

    element :email, String
    element :name, String
    element :url, String, :tag => "uri"

  end

end

