require 'open-uri'
require 'nokogiri'

module CatalogQuery
  GENRE_URL_BEG = 'http://libcat.dartmouth.edu/search/X?s:'.freeze
  GENRE_URL_END = '%20and%20branch:branchbajmz'.freeze

  # Query for a genre and returns bibnumber of results.
  #
  # @params genre [String] genre to be queried for
  # @returns [Array<String>] where each string is a bibnumber
  def self.genre_query(genre)
    page = Nokogiri::HTML(open(genre_url(genre)))
    bibnumber_nodes = page.xpath('//td[@class=\'briefcitActions\']/input/@value')

    # If there is only one result the entire record is displayed, therefore the
    # bibnumber is derived differently than if multiple results are shown.
    if bibnumber_nodes.count == 0
      'only one result'
    else
      bibnumber_nodes.map(&:value)
    end

    #returns results
  end

  def self.genre_url(genre)
    urls = {
      adventure: common_genre_url('adventure%20films'),
  		animation: common_genre_url('Animated%20films'),
  		children: "http://libcat.dartmouth.edu/search~S1?/Xs:children%27s%20films%20and%20branch:branchbajmz",
  		comedy: common_genre_url("comedy%20films"),
  		crime: common_genre_url("crime%20films"),
  		documentary: common_genre_url("documentary%20films"),
  		drama: common_genre_url("drama%20films"),
  		historical: common_genre_url("Historical%20films"),
  		horror: common_genre_url("horror%20films"),
  		romance: common_genre_url("Romance%20films"),
  		science_fiction: common_genre_url("Science%20Fiction"),
  		television_programs: "http://libcat.dartmouth.edu/search~S4?/dTelevision+programs./dtelevision+programs/-3%2C-1%2C0%2CB/exact&FF=dtelevision+programs&1%2C165%2C",
  		war: common_genre_url("war%20films"),
  		western: common_genre_url("western*"),
    }
    (urls.key? genre) ? urls[genre] : false;
  end

  private

  def self.common_genre_url(query)
    GENRE_URL_BEG + query + GENRE_URL_END
  end
end
