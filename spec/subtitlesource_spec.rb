require "spec_helper"

describe Subtitlesource do
  def did_request?(path)
    a_request(:get, "http://www.subtitlesource.org/api/#{@s.api_key}/3.0/#{path}").should have_been_made.once
  end
  
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
      
      did_request?("xmlsearch/heroes/english/0")
    end

    it "should be possible to search for a query with whitespace" do
      VCR.use_cassette("prison-break-english") do
        @s.query("prison break").language("Swedish").fetch
      end
      
      did_request?("xmlsearch/prison%20break/swedish/0")
    end

    it "should be possible to list subtitles for any language" do
      VCR.use_cassette("heroes-any-language-english") do
        @s.query("Heroes.S03E09.HDTV.XviD-LOL").fetch
      end

      did_request?("xmlsearch/Heroes.S03E09.HDTV.XviD-LOL/all/0")
    end

    it "should list all subtitles related to an imdb id" do
      VCR.use_cassette("imdb-0813715") do
        @s.imdb("0813715").fetch
      end
      
      did_request?("xmlsearch/0813715/imdb/0")
      
      VCR.use_cassette("imdb-0813715-page-2") do
        @s.page(2).imdb("tt0813715").fetch
      end
      
      did_request?("xmlsearch/0813715/imdb/20")
    end
    
    it "should be possible to set a page" do
     VCR.use_cassette("imdb-page-2") do
        @s.page(2).imdb("0813715").fetch
      end

      did_request?("xmlsearch/0813715/imdb/20")
    end
    
    it "should be able to cache" do
      VCR.use_cassette("imdb-page-2") do
         5.times { @s.page(2).imdb("0813715").fetch }
       end
       
       did_request?("xmlsearch/0813715/imdb/20")
    end
    
    it "should use the current url as cache key" do
      VCR.use_cassette("imdb-page-2") do
        3.times { @s.page(1).imdb("0813715").fetch }
        3.times { @s.page(2).imdb("0813715").fetch }
      end
      
      did_request?("xmlsearch/0813715/imdb/0")
      did_request?("xmlsearch/0813715/imdb/20")
    end
  end
  
  describe "data" do
    use_vcr_cassette("imdb-0813715")
    it "should return 20 subtitles" do
      fetch = @s.imdb("0813715").fetch
      fetch.count.should eq(20)
      fetch.should be_instance_of(SubtitlesourceModule::Subtitles)
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
    
    it "should return the correct imdb id" do
      @s.imdb("0813715").fetch.first.imdb.should eq("tt0813715")
    end
    
    it "should be able to generate an details link" do
      sub = @s.imdb("0813715").fetch.first
      
      VCR.use_cassette("0813715-details") do
        lambda {
          RestClient.get(sub.details)
        }.should_not raise_error(RestClient::Exception)
      end
      
      a_request(:get, "http://www.subtitlesource.org/subs/#{sub.id}/#{sub.releasename}").should have_been_made.once      
    end
    
    it "should have a direct download url" do
      sub = @s.imdb("0813715").fetch.first
      
      VCR.use_cassette("0813715-url") do
        lambda {
          RestClient.get(sub.url)
        }.should_not raise_error(RestClient::Exception)
      end
      
      a_request(:get, "http://www.subtitlesource.org/download/zip/#{sub.id}").should have_been_made.once
    end
  end
end