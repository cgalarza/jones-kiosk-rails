require 'catalog_query'
require 'jones_kiosk/movie_record'


class BrowseController < ApplicationController
  # GET browse
  # Query String: genre=""
  def index
    bibnumbers = CatalogQuery.genre_query(:animation)

    @records = bibnumbers.map do |bibnumber|
      JonesKiosk::MovieRecord.new(bibnumber)
      # find image for movie_record
    end

    puts "records: " + @records.to_s
    # method to go from marc record to movie relavent fields
  end
end
