# frozen_string_literal: true

class DropRetweetsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :retweets # rubocop:disable Rails/ReversibleMigration
  end
end
