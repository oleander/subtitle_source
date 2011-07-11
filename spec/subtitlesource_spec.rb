require "spec_helper"

describe Subtitlesource do
  before(:each) do
    @s = Subtitlesource.new(ENV["API_KEY"])
  end
  
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
end