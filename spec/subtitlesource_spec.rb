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
end