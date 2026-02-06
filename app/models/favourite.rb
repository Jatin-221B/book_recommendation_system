class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, uniqueness: { scope: :book_id }

  after_create :log_favourite

  def log_favourite
    Rails.logger.info("User #{user_id} favourited book #{book_id}")
  end
end
