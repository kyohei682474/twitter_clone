# frozen_string_literal: true

class AddUniqueIndexToEntries < ActiveRecord::Migration[7.0]
  def change
    add_index :entries, %i[user_id room_id], unique: true
  end
end
