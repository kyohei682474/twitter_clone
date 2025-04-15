class AddProfileDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :location, :string
    add_column :users, :website, :string
  end
end
