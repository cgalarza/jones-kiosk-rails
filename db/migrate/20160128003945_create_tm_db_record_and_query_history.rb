class CreateTmDbRecordAndQueryHistory < ActiveRecord::Migration
  def change
    create_table :query_histories do |t|
      t.datetime :date
      t.string   :bibnumber
    end

    create_table :tmdb_records do |t|
      t.belongs_to :query_history, index: true
      t.string :poster_url
      t.string :imdb_id
      t.datetime :created_at
      t.datetime :update_at
    end
  end
end
