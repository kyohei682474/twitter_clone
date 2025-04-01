class ChangePhoneAndBirthdateNullableInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :phone_number, true
    change_column_null :users, :birthdate, true
  end
end
