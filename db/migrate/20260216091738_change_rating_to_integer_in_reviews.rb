class ChangeRatingToIntegerInReviews < ActiveRecord::Migration[8.1]
  def up
    # Convert existing string ratings to integers
    change_column :reviews, :rating, 'integer USING CAST(rating AS integer)'
  end

  def down
    # In case you need to rollback
    change_column :reviews, :rating, :string
  end
end
