require "rest_client"
require "nokogiri"
require "uri"

class Subtitlesource
  attr_reader :api_key
  
  def initialize(api_key)
    @api_key = api_key
    unless @api_key
      raise ArgumentError.new("You must specify an Subtitlesource API key.")
    end
  end
  
  def query(query)
    tap { @query = URI.escape(query) }
  end
  
  def language(language)
    tap { @language = language.to_s.downcase }
  end
  
  def imdb(imdb)
    tap { @imdb = imdb }
  end
  
  def page(page)
    tap { @page = page - 1 }
  end
  
  def fetch
    content
  end
  
  private
    
    def content
      subtitle = Struct.new(:title, :imdb, :id, :rid, :language, :season, :episode, :releasename, :fps, :cd, :hi)
      Nokogiri::XML(get).css("subtitlesource xmlsearch sub").map do |sub|
        subtitle.new(
          sub.at_css("title").content, 
          sub.at_css("imdb").content, 
          sub.at_css("id").content.to_i,
          sub.at_css("rid").content.to_i,
          sub.at_css("language").content,
          sub.at_css("season").content.to_i,
          sub.at_css("episode").content.to_i,
          sub.at_css("releasename").content,
          sub.at_css("fps").content.to_i,
          sub.at_css("cd").content.to_i,
          sub.at_css("hi").content.to_i,
        )
      end
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
      "http://www.subtitlesource.org/api/#{@api_key}/3.0/xmlsearch/#{part}/#{@page.to_i * 20}"
    end
end
