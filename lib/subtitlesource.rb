class Subtitlesource
  def initialize(api_key)
    @api_key = api_key
    unless @api_key
      raise ArgumentError.new("You must specify an Subtitlesource API key.")
    end
  end
end
