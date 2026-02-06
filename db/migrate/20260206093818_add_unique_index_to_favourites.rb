class AddUniqueIndexToFavourites < ActiveRecord::Migration[8.1]
  def change
    add_index :favourites, [ :user_id, :book_id ], unique: true
  end
end
