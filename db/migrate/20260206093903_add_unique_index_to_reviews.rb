class AddUniqueIndexToReviews < ActiveRecord::Migration[8.1]
  def change
    add_index :reviews, [ :user_id, :book_id ], unique: true
  end
end
