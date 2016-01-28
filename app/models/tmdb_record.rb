class TmdbRecord < ActiveRecord::Base
  belongs_to :query_history
  validates :query_history, :imdb_id, :poster_url, presence: true
end
