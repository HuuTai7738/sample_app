class AddIndexToUsersEmail < ActiveRecord::Migration[7.0]
  def change
    add_index :users, unique: true
  end
end
