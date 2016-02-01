require 'sierra_api'

module JonesKiosk
  class MovieRecord
    @@sierra_api = SierraApi.new

    attr_reader :bibnumber, :title

    #This object should contain: bibnumber, title, summary, cast, language, rating, note
    #poster_url?
    def initialize(bibnumber)
      @bibnumber = bibnumber

      load_marc_record
      # get_poster_url if @title and whatever other fields we need to do the search
    end

    # Load information for marc record.
    #marc record is going to be in json format
    # @return [Hash]
    def load_marc_record
      @@sierra_api = SierraApi.new unless @@sierra_api

      marc_record = @@sierra_api.bibs(id: @bibnumber)

      relavent_tags = ['245', '500', '511', '520', '521', '546']
      tags = marc_record.select{ |i| relavent_tags.include?(i['tag']) }

      movie_record = { bibnumber: bibnumber }

      # Extract title.
      title_tags = tags.select{ |t| t['tag'] == '245' }
      if title_tags.count == 1
        subfield = title_tags.first['data']['subfields'].select{ |t| t['code'] == 'a' }
        @title = subfield.first['data']
      end

      # Extract summary.
      summary_tags = tags.select{ |t| t['tag'] == '520' }

      puts "Movie Record: " + movie_record.to_s
    end
  end
end
