class PagesController < ApplicationController
  def home
    @recent_books = Book.includes(:author).order(created_at: :desc).limit(5)
  end
end
