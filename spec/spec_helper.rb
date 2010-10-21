require 'rspec'

require File.dirname(__FILE__) + '/../lib/mochi.rb'
#require File.expand_path("../../app/models/mochi/game.rb", __FILE__)
#require File.expand_path("../../app/models/mochi/feed.rb", __FILE__)

def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end

