require File.dirname(__FILE__) + '/spec_helper.rb'

describe Mochi::Feed do

  before(:all) do
    @xml = fixture_file("feed.xml")
    @games = Mochi::Game.parse(@xml)
    @feed  = Mochi::Feed.parse(@xml)
    @game  = @games.first
  end

  subject { @feed }

  context "with valid feed elements from xml" do
    its(:id) { should eql "urn:uuid:6b91fc41-ef25-4e91-ae40-f98a1e7b802a" }
    its(:title) { should eql "Mochi Games" }
    its(:subtitle) { should eql "Free Games for Portals" }
    its(:icon) { should eql "http://www.mochimedia.com/favicon.ico" }
    its('updated.to_s') { should eql "Tue Aug 03 19:19:58 UTC 2010" }
  end

  context "when its link has url" do
    its(:url) { should eql @feed.link.url }
  end

  describe "author" do
    subject { @feed.author }

    its(:name) { should eql "Mochi Media, Inc." }
    its(:email) { should eql "team@mochimedia.com" }
    its(:url) { should eql "team.mochimedia.com" }
  end

  describe "link" do
    subject { @feed.link }

    its(:url) { should eql "http://www.mochimedia.com/feeds/games" }
    its(:rel) { should eql "self" }
  end

  describe "parsed games array" do
    subject { @games }

    it { should have(5).elements }
  end

  describe "game entrie" do
    subject { @game }

    context "with valid elements from xml" do
      its(:id) { should eql "urn:uuid:6591f99d-642f-3415-971e-98cd79f57998" }
      its(:title) { should eql "cling" }
      its("updated.to_s") { should eql "Tue Aug 03 11:44:36 +0200 2010" }
      its("published.to_s") {  should eql "Tue Aug 03 11:44:36 +0200 2010" }
      its(:description) { should eql "Welcome to cling! Your goal is to help Edgar the electric spider to the goal at the end of each level." }
      its(:links) { should have(2).links }
    end

    describe "thumbnail" do
      subject { @game.thumbnail }

      it { should eql "" }
      its(:height) { should eql 100 }
      its(:width) { should eql 120 }
      its(:url) { should eql "http://thumbs.mochiads.com/c/g/cling/_thumb_100x100.png" }
    end

    describe "player" do
      subject { @game.player }

      it { should eql "" }
      its(:height) { should eql 600 }
      its(:width) { should eql 620 }
      its(:url) { should eql "http://games.mochiads.com/c/g/cling/cling.swf" }
    end

    describe "keywords array" do
      subject { @game.keywords }

      it { should eql %w(cling edgar electric) }

      context "when tag is blank" do
        subject { @games[1].keywords }
        it { should be_empty }
      end

      context "when tag doesn't exists" do
        subject { @games[2].keywords }
        it { should be_empty }
      end
    end

    describe "links" do
      subject { @game.links.map{|link| [link.url, link.rel, link.file_type] }}

      its(:first) { should eql ["http://www.mochimedia.com/games/cling",'alternate',''] }
      specify "should contain table of strings" do
        subject[1].should eql ["http://games.mochiads.com/c/g/cling/cling.swf",'enclosure','application/x-shockwave-flash']
      end
    end

    describe "categories" do
      subject { @game.categories }

      it { should eql %w(Action Other) }

      context "when tag categories doesn't exists" do
        subject { @games[1].categories }
        it { should be_empty }
      end

    end

    describe "details array " do
      subject { @game.details }

      it { should be_a Array }
      it { should have(15).elements }
      its("first.detail_type") { should eql "tag" }
      its("first.value") { should eql "17466d6f69a60aa2" }

      it "shouldn't have detail without value" do
        subject.each {|detail| detail.detail_type.should_not eql "" }
      end

      describe "embed detail" do
        subject { @game.details.find{|detail| detail.detail_type == 'embed'} }

        it { should_not be_nil }
        its(:value) { should eql 'Embed code' }
      end
    end

    describe "summary hash" do
      subject { @game.summary }

      its(:size) { should eql 15 }
    end
  end

end
