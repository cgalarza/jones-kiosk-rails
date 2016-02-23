require 'open-uri'
require 'nokogiri'

module CatalogQuery
  KEYWORD_SEARCH_BEG = "http://libcat.dartmouth.edu/search/X?SEARCH="
  KEYWORD_SEARCH_END = "+and+(branch%3Abranchbajmz+or+branch%3Abranchbajmv+or+branch%3Abranchrsjmc)&searchscope=4&SORT=R&Da=&Db=&p="

  GENRE_URL_BEG = 'http://libcat.dartmouth.edu/search/X?s:'.freeze
  GENRE_URL_END = '%20and%20branch:branchbajmz'.freeze

  # Keyword query catalog for dvds at Jones.
  #
  # @param search_term [String]
  # @return [Array<String>] where each string is a bibnumber
  def keyword_query(search_term)
    raise 'Missing search term' unless search_term

    url = [KEYWORD_SEARCH_BEG, search_term.gsub(' ', '+'), KEYWORD_SEARCH_END].join('');
    CatalogQuery.query(url)
  end

  # Query for a genre and returns bibnumber of results.
  #
  # @param genre [String] genre to be queried for
  # @return [Array<String>] where each string is a bibnumber
  def self.genre_query(genre)
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
    url = (urls.key? genre) ? urls[genre] : false;
    CatalogQuery.query(url)
  end

  # Query library catalog using url given and return array of the first 50
  # bibnumbers returned.
  #
  # @param url [String] catalog url of query
  # @return [Array<String>] where each string is a bibnumber
  def self.query(url)
    page = Nokogiri::HTML(open(url))
    bibnumber_nodes = page.xpath('//td[@class=\'briefcitActions\']/input/@value')

    # If there is only one result the entire record is displayed, therefore the
    # bibnumber is derived differently than if multiple results are shown.
    if bibnumber_nodes.count == 0
      'only one result'
    else
      bibnumber_nodes.map(&:value).each { |b| b[0] = '' }# remove 'b'
    end
    #returns results
  end

  private

  def self.common_genre_url(query)
    GENRE_URL_BEG + query + GENRE_URL_END
  end
end
