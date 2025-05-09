class ChangeRetweetedFromForeignKeyOnTweets < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :tweets, column: :retweeted_from_id
    add_foreign_key :tweets, :tweets, column: :retweeted_from_id, on_delete: :nullify
  end
end
