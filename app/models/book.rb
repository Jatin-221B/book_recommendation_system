class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :reviewers, through: :reviews, source: :user
  has_many :favourites, dependent: :destroy
  has_many :fans, through: :favourites, source: :user

  belongs_to :author

  validates :title, presence: true, uniqueness: { scope: :author_id, message: "already exists for this author" }
  validates :genre, presence: true, inclusion: { in: [ "Unknown", "Fiction", "Mystery", "Fantasy", "Romance", "Thriller", "Horror", "Philosophy", "Educational", "Self-help" ] }
  validates :description, presence: true, length: { minimum: 20 }

  before_validation :format_title
  before_validation :default_genre

  private

  def format_title
    self.title = title.titleize if title.present?
  end

  def default_genre
    self.genre ||= "Unknown"
  end
end
