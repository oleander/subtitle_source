require "spec_helper"

describe Subtitlesource do
  before(:each) do
    @s = Subtitlesource.new(ENV["API_KEY"])
  end
  
  describe "requests" do
    it "should raise an error if no key is given" do
      lambda { 
        Subtitlesource.new(nil)
      }.should raise_error(ArgumentError, "You must specify an Subtitlesource API key.")
    end

    it "should be possible to set a language" do
      VCR.use_cassette("heroes-english") do
        @s.query("heroes").language("English").fetch
      end

      a_request(:get, "http://www.subtitlesource.org/api/#{@s.api_key}/3.0/xmlsearch/heroes/english/0").should have_been_made.once
    end

    it "should be possible to search for a query with whitespace" do
      VCR.use_cassette("prison-break-english") do
        @s.query("prison break").language("Swedish").fetch
      end

      a_request(:get, "http://www.subtitlesource.org/api/#{@s.api_key}/3.0/xmlsearch/prison%20break/swedish/0").should have_been_made.once
    end

    it "should be possible to list subtitles for any language" do
      VCR.use_cassette("heroes-any-language-english") do
        @s.query("Heroes.S03E09.HDTV.XviD-LOL").fetch
      end

      a_request(:get, "http://www.subtitlesource.org/api/#{@s.api_key}/3.0/xmlsearch/Heroes.S03E09.HDTV.XviD-LOL/all/0").should have_been_made.once
    end

    it "should list all subtitles related to an imdb id" do
      VCR.use_cassette("imdb-0813715") do
        @s.imdb("0813715").fetch
      end

      a_request(:get, "http://www.subtitlesource.org/api/#{@s.api_key}/3.0/xmlsearch/0813715/imdb/0").should have_been_made.once
    end
  end
  
  describe "data" do
    use_vcr_cassette("imdb-0813715")
    it "should return 20 subtitles" do
      fetch = @s.imdb("0813715").fetch
      fetch.count.should eq(20)
      fetch.should be_instance_of(Array)
      fetch.first.title.should be_instance_of(String)
      fetch.first.imdb.should be_instance_of(String)
      fetch.first.id.should be_instance_of(Fixnum)
      fetch.first.rid.should be_instance_of(Fixnum)
      fetch.first.language.should be_instance_of(String)
      fetch.first.season.should be_instance_of(Fixnum)
      fetch.first.episode.should be_instance_of(Fixnum)
      fetch.first.releasename.should be_instance_of(String)
      fetch.first.fps.should be_instance_of(Fixnum)
      fetch.first.cd.should be_instance_of(Fixnum)
      fetch.first.hi.should be_instance_of(Fixnum)
    end
  end
end