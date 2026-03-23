# app/models/book.rb
class Book < ApplicationRecord
  belongs_to :author
  has_many :reviews, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user
  has_many :favourites, dependent: :destroy
  has_many :fans, through: :favourites, source: :user

  GENRES = [
    "Unknown", "Fiction", "Non-Fiction", "Science Fiction",
    "Fantasy", "Mystery", "Thriller", "Horror", "Romance",
    "Classic", "Adventure", "Biography", "History",
    "Philosophy", "Educational", "Self-help"
  ].freeze

  validates :title, presence: true
  validates :title, uniqueness: { scope: :author_id }
  validates :genre, presence: true, inclusion: { in: GENRES }
  validates :description, presence: true, length: { minimum: 20 }

  before_save :set_default_genre
  before_save :titleize_title

  # Get cover image URL with fallback
  def cover_url
    cover_image_url.presence || placeholder_cover
  end

  private

  def set_default_genre
    self.genre ||= "Unknown"
  end

  def titleize_title
    self.title = title.titleize if title.present?
  end

  def placeholder_cover
    # Simple placeholder with book emoji
    "https://via.placeholder.com/300x450/e8e8e8/666666?text=📚"
  end
end
