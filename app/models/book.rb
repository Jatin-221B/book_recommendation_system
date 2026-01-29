class Book < ApplicationRecord
  has_many :reviews

  validates :title, presence: true, uniqueness: true
  validates :author, presence: true
  validates :genre, inclusion: { in: [ "Unknown", "Fiction", "Mystery", "Fantasy", "Romance", "Thriller", "Horror", "Philosophy", "Educational", "Self-help" ] }
  validates :description, presence: true, length: { minimum: 20 }

  before_save :format_title
  before_validation :default_genre

  def format_title
    self.title = title.titleize
  end

  def default_genre
    self.genre ||= "Unknown"
  end
end
