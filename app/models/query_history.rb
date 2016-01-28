class QueryHistory < ActiveRecord::Base
	has_one :tmdb_record
	validates :date, :bibnumber, presence: true
end
