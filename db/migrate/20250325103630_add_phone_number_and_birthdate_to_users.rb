# frozen_string_literal: true

class AddPhoneNumberToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :phone_number, null: false, default: ''
      # rubocop:disable Rails/NotNullColumn
      t.date :birthdate, null: false
      # rubocop:enable Rails/NotNullColumn
    end

    add_index :users, :phone_number, unique: true
  end
end
