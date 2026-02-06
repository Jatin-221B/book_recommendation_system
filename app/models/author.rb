class Author < ApplicationRecord
  has_many  :books, dependent: :restrict_with_error

  validates :name, presence: true
  validates :bio, presence: true

  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.titleize if name.present?
  end
end
