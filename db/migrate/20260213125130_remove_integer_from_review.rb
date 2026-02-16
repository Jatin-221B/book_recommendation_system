class RemoveIntegerFromReview < ActiveRecord::Migration[8.1]
  def change
    remove_column :reviews, :Integer, :string
  end
end
