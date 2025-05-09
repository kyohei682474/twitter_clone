class AddRetweetedFromToTweets < ActiveRecord::Migration[7.0]
  def change
    add_reference :tweets, :retweeted_from, null: true, foreign_key: { to_table: :tweets }
  end
end
