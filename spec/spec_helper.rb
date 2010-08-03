require 'spec'
require File.expand_path("../../app/models/mochi/feed.rb", __FILE__)

def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end

