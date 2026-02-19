class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :reviewed_books, through: :reviews, source: :book
  has_many :favourited_books, through: :favourites, source: :book

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :format_email

  private

  def format_email
    self.email = email.downcase.strip if email.present?
  end
end
