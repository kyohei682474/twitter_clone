# frozen_string_literal: true

class AddUniqueIndexToLikes < ActiveRecord::Migration[7.0]
  def change
    # likesテーブルのtweet_idとuser_idの組み合わせにユニークインデックスを追加
    add_index :likes, %i[user_id tweet_id], unique: true
  end
end
