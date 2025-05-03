# frozen_string_literal: true

class AddForeignKeyToCommentsUser < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :comments, :users if foreign_key_exists?(:comments, :users)
    remove_foreign_key :comments, :tweets if foreign_key_exists?(:comments, :tweets)

    add_foreign_key :comments, :users, on_delete: :cascade
    add_foreign_key :comments, :tweets, on_delete: :cascade
  end
end
