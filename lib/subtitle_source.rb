require "rest_client"
require "subtitle_source/array"
require "nokogiri"
require "uri"
require "cgi"

class SubtitleSource
  attr_reader :api_key
  
  def initialize(api_key)
    @api_key = api_key
    unless @api_key
      raise ArgumentError.new("You must specify an Subtitle Source API key.")
    end
  end
  
  def query(query)
    tap do 
      @query = URI.escape(query)
      @imdb = nil
    end
  end
  
  def language(language)
    tap do 
      @language = language.to_s.downcase
      @imdb = nil
    end
  end
  
  def imdb(imdb)
    tap do 
      @imdb = imdb.to_s.match(/^(tt)?(\d+)/).to_a[2]
      @language = nil; @query = nil
    end
  end
  
  def page(page)
    tap { @page = page - 1 }
  end
  
  def fetch
    content
  end
  
  private
    
    def content
      subtitle = Struct.new(
        :title, 
        :imdb, 
        :id, 
        :rid, 
        :language, 
        :season, 
        :episode, 
        :release_name, 
        :fps, 
        :cd, 
        :hi, 
        :details,
        :url
      )
      
      subtitles = Nokogiri::XML(get).css("subtitlesource xmlsearch sub").map do |sub|
        subtitle.new(
          sub.at_css("title").content, 
          "tt#{sub.at_css("imdb").content}",
          sub.at_css("id").content.to_i,
          sub.at_css("rid").content.to_i,
          sub.at_css("language").content,
          sub.at_css("season").content.to_i,
          sub.at_css("episode").content.to_i,
          sub.at_css("releasename").content,
          sub.at_css("fps").content.to_i,
          sub.at_css("cd").content.to_i,
          sub.at_css("hi").content.to_i,
          "http://www.subtitlesource.org/subs/#{sub.at_css("id").content}/#{sub.at_css("releasename").content}",
          "http://www.subtitlesource.org/download/zip/#{sub.at_css("id").content}"
        )
      end
      
      SubtitleSourceModule::Subtitles.new(subtitles)
    end
    
    def get
      (@get ||= {})[url] ||= RestClient.get(url, timeout: 10)
    end
    
    def url
      if @query
        part = "#{@query}/#{@language || "all"}"
      elsif @imdb
        part = "#{@imdb}/imdb"
      end
      
      "http://www.subtitlesource.org/api/#{@api_key}/3.0/xmlsearch/#{part}/#{@page.to_i * 20}".gsub(/\{|\}|\||\\|\^|\[|\]|\`|\s+/) do |m| 
        CGI::escape(m)
      end
    end
end
