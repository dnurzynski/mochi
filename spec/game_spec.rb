require File.dirname(__FILE__) + '/spec_helper.rb'

describe Mochi::Game do

  describe "Feed" do
    before(:all) do
      @xml = fixture_file("feed.xml")
      @games = Mochi::Game.parse(@xml)
      @feed  = Mochi::Feed.parse(@xml)
      @game = @games.first
    end

    it "game entries should equall game feed entries" do
      @games == @feed.games
    end

    it "should contain 5 games" do
      @games.size.should == 5
    end

    it "should include valid feed elements from xml" do
      @feed.id.should == "urn:uuid:6b91fc41-ef25-4e91-ae40-f98a1e7b802a"
      @feed.title.should == "Mochi Games"
      @feed.subtitle.should == "Free Games for Portals"
      @feed.icon.should == "http://www.mochimedia.com/favicon.ico"
      @feed.updated.to_s.should == "Tue Aug 03 19:19:58 UTC 2010"
    end

    it "should include valid author" do
      @feed.author.name.should == "Mochi Media, Inc."
      @feed.author.email.should == "team@mochimedia.com"
      @feed.author.url.should == "team.mochimedia.com"
    end

    it "should include valid link" do
      @feed.link.url.should == "http://www.mochimedia.com/feeds/games"
      @feed.url.should == @feed.link.url
      @feed.link.rel.should == "self"
    end

    describe "game entrie" do

      it "should include valid elements from xml" do
        @game.title.should == "cling"
        @game.updated.to_s.should == "Tue Aug 03 11:44:36 +0200 2010"
        @game.published.to_s.should == "Tue Aug 03 11:44:36 +0200 2010"
        @game.description.should == ""
#        @game.id.should == ""
      end

    end

  end
end
