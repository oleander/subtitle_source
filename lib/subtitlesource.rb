require "rest_client"
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
  
  def fetch
    (@_fetch ||= {})[url] ||= RestClient.get(url, timeout: 10)
  end
  
  private
    def url
      if @query
        part = "#{@query}/#{@language || "all"}"
      elsif @imdb
        part = "#{@imdb}/imdb"
      end
      
      "http://www.subtitlesource.org/api/#{@api_key}/3.0/xmlsearch/#{part}/0"
    end
end
