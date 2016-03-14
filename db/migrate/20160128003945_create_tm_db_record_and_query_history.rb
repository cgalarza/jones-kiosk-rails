class CreateTmDbRecordAndQueryHistory < ActiveRecord::Migration
  def change
    create_table :query_histories do |t|
      t.datetime :date, null: false
      t.string   :bibnumber, null: false
    end

    create_table :tmdb_records do |t|
      t.belongs_to :query_history, index: true
      t.string :poster_url, null: false
      t.string :imdb_id, null: false

      t.timestamps null: false
    end
  end
end
