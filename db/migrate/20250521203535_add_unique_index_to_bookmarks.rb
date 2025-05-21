class AddUniqueIndexToBookmarks < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        add_index :bookmarks, %i[user_id tweet_id], unique: true
      end

      dir.down do
        remove_index :bookmarks, column: %i[user_id tweet_id]
      end
    end
  end
end
