class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  change_table :users do |t|
    t.string :provider
    t.string :uid
  end
  add_index :users, %i[provider uid], unique: true
end
