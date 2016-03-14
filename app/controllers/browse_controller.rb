require 'catalog_query'
require 'jones_kiosk/movie_record'

class BrowseController < ApplicationController
  # GET browse
  # Query String: genre=""
  def index

    if params[:genre]
      bibnumbers = CatalogQuery.genre_query(params[:genre].to_sym)

      @records = bibnumbers.map do |bibnumber|
        JonesKiosk::MovieRecord.new(bibnumber)
        # find image for movie_record
      end

      puts "records: " + @records.to_s
    end
  end
end
