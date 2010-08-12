require File.dirname(__FILE__) + '/spec_helper.rb'

describe Mochi::Feed do

  describe "Feed" do
    before(:all) do
      @xml = fixture_file("feed.xml")
      @games = Mochi::Game.parse(@xml)
      @feed  = Mochi::Feed.parse(@xml)
      @game  = @games.first
    end

    it "game entries should equall game feed entries" do
      @games == @feed.games
    end

    it "should contains 5 games" do
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
        @game.description.should == "Welcome to cling! Your goal is to help Edgar the electric spider to the goal at the end of each level."
        @game.id.should == "urn:uuid:6591f99d-642f-3415-971e-98cd79f57998"
      end

      it "should has one thumbnail element with valid attributes" do
        thumbnail = @game.thumbnail
        thumbnail.should == ""
        [thumbnail.height,thumbnail.width,thumbnail.url].should == [100,120,"http://thumbs.mochiads.com/c/g/cling/_thumb_100x100.png"]
      end

      it "should has one media player element with valid attributes" do
        player = @game.player
        player.should == ""
        [player.height,player.width,player.url].should == [600,620,"http://games.mochiads.com/c/g/cling/cling.swf"]
      end

      it "should has one keywords array" do
        @game.keywords.should == %w(cling edgar electric)
        @games[1].keywords.should be_empty # tag blank
        @games[2].keywords.should be_empty # tag doesn't exists
      end

      it "should have 2 links with different types" do
        @game.links.should have(2).links
      end

      it "should have links with valid attributes" do
        link_attributes = @game.links.map{|link| [link.url, link.rel, link.file_type] }
        link_attributes.first.should == ["http://www.mochimedia.com/games/cling",'alternate','']
        link_attributes[1].should == ["http://games.mochiads.com/c/g/cling/cling.swf",'enclosure','application/x-shockwave-flash']
      end 

      it "should have parsed categories array" do
        @game.categories.should == %w(Action Other)
        @games[1].categories.should be_empty # tag doesn't exists
      end

      it "should have parsed game details array " do
        @game.details.class.should == Array
        @game.details.should have(15).elements
        @game.details.first.detail_type.should == "tag"
        @game.details.first.value.should == "17466d6f69a60aa2"
      end

      it "shouldn't have detail without value" do
        @game.details.each {|detail| detail.detail_type.should_not == "" }
      end

      it "should have valid parsed detail 'embed'" do
        embed = @game.details.find{|detail| detail.detail_type == 'embed'}
        embed.should_not be_nil
        embed.value.should == 'Embed code'
      end

      it "should create summary hash from details" do
        @game.summary.map{|k,v| k}.size.should == 15
      end
    end

  end
end
