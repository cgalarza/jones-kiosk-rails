require 'sierra_api'

module JonesKiosk
  class MovieRecord
    @@sierra_api = SierraApi.new

    attr_reader :bibnumber, :title, :summary, :cast, :language, :rating

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

      tags = {}
      marc_record.each do |i|
        tag = i['tag']
        if relavent_tags.include?(tag)
          tags[tag] = {} unless tags.key?(tag)

          i['data']['subfields'].each do |j|
            code = j['code']
            if tags[tag].key?(code)
              tags[tag][code] << ' ' + j['data']
            else
              tags[tag][code] = j['data']
            end
          end
        end
      end
      #pp tags

      # Extract fields.
      @title = tags['245']['a'] if defined?(tags['245']['a'])
      @summary = tags['520']['a'] if defined?(tags['520']['a'])
      @cast = tags['511']['a'] if defined?(tags['511']['a'])
      @language = tags['546']['a'] if defined?(tags['546']['a'])
      @rating = tags['521']['a'] if defined?(tags['521']['a'])

    end
  end
end
