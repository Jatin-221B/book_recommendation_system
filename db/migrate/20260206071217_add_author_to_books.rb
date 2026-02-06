class AddAuthorToBooks < ActiveRecord::Migration[8.1]
  def change
    add_reference :books, :author, null: false, foreign_key: true
  end
end
