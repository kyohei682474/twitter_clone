# frozen_string_literal: true

class AddProfileDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.text :bio
      t.string :location
      t.string :website
    end
  end
end
