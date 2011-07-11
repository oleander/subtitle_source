require "spec_helper"

describe SubtitlesourceModule::Subtitles do
  use_vcr_cassette "tt0840361"
  
  before(:each) do
    @subtitles = Subtitlesource.new(ENV["API_KEY"]).imdb("0813715").fetch
  end
  
  it "should have a based_on method" do
    lambda{
      @subtitles.based_on("some args")
    }.should_not raise_error(NoMethodError)
  end
  
  it "return the best result" do
    string = "Heroes.S04E18.720p.HDTV.X264-DIMENSION"
    @subtitles.based_on(string).release_name.should eq(string)
  end    
  
  it "should not return anything if the limit is set to low" do
    @subtitles.based_on("Heroes.S04E18.720p.HDTV.X264", limit: 0).should be_nil
  end
  
  it "should not return the right movie if to litle info i passed" do
    @subtitles.based_on("heroes").should be_nil
  end
  
  it "should return nil if trying to fetch an non existing imdb id" do
    SubtitlesourceModule::Subtitles.new([]).based_on("some random argument").should be_nil
  end

  it "should raise an exception when the array does not contain any subtitle objects" do
    lambda {
      [1,2,2,3].based_on("some args")
    }.should raise_error(NoMethodError)
  end
  
  it "should return nil due to the release date {S04E18}" do
    @subtitles.based_on("Heroes.S04E49.720p.HDTV.X264").should be_nil
  end
  
  it "should not return anything due to the wrong year" do
    @subtitles.based_on("Heroes.S04E49.720p.HDTV.X264.2011").should be_nil
  end
end