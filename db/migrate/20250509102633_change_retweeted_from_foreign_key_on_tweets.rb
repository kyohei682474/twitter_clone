# frozen_string_literal: true

class ChangeRetweetedFromForeignKeyOnTweets < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        remove_foreign_key :tweets, column: :retweeted_from_id
        add_foreign_key :tweets, :tweets, column: :retweeted_from_id, on_delete: :nullify
      end

      dir.down do
        remove_foreign_key :tweets, column: :retweeted_from_id
        add_foreign_key :tweets, :tweets, column: :retweeted_from_id
      end
    end
  end
end
