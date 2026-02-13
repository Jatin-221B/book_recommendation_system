class BooksController < ApplicationController
  def index
    @book = Book.includes(:author)
  end

  def show
    @book = Book.includes(:author, reviews: :user).find(params[:id])
    @reviews = @book.reviews.order(created_at: :desc)
    @average_rating = @book.reviews.average(:rating)&.round(1)
  end
end
