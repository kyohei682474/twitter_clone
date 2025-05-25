class RenameContextToContentInChats < ActiveRecord::Migration[7.0]
  def change
    rename_column :chats, :context, :content
  end
end
