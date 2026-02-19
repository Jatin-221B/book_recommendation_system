class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :content, length: { maximum: 500 }, allow_blank: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :user_id, uniqueness: { scope: :book_id, message: "has already reviewed this book" }

  # Ensure rating is always integer
  def rating
    super&.to_i
  end

  def rating=(value)
    super(value.to_i)
  end
end
