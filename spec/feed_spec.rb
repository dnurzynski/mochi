require File.dirname(__FILE__) + '/spec_helper.rb'

describe Mochi::Feed do

  it "should exists!" do
    feed = Mochi::Feed.new
    feed.name == Mochi::Feed.new.name
    puts fixture_file("feed.xml")
  end
end
