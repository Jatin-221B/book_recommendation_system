class User < ApplicationRecord
  has_many :reviews

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :format_email

  def format_email
    self.email = email.downcase.strip
  end
end
