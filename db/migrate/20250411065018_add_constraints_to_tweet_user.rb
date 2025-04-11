class AddConstraintsToTweetUser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tweets, :user_id, false
  end
end
