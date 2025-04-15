# frozen_string_literal: true

class ChangePhoneAndBirthdateNullableInUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.change_null :phone_number, true
      t.change_null :birthdate, true
    end
  end
end
