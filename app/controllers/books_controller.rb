class BooksController < ApplicationController
  def index
    @books = Book.includes(:author).page(params[:page]).per(12)
  end

  def show
    @book = Book.includes(:author, reviews: :user).find_by(id: params[:id])
    if !@book.nil?
      # @current_user_review = nil
      # @other_reviews = []

      # if current_user
      #   @current_user_review = @book.reviews.find_by(user_id: current_user.id)
      # end

      # @other_reviews = @book.reviews.where.not(user_id: current_user.id)
      # @reviews =[]
      # @reviews << @current_user_review if @current_user_review
      # @reviews += @other_reviews

      @reviews = @book.reviews.order(created_at: :desc)
      if !@reviews.empty?
        @average_rating = @reviews.average(:rating).round(1)
      end
    end
    @review = Review.new
  end

  def search
    @query = params[:q]

    if @query.present?
      @books = Book.includes(:author)
                   .where("LOWER(books.title) LIKE ? OR LOWER(authors.name) LIKE ?",
                          "%#{@query.downcase}%",
                          "%#{@query.downcase}%")
                   .references(:authors)
                   .order(title: :asc)
                   .page(params[:page])
                   .per(24)
    else
      @books = Book.none.page(params[:page])
    end
  end
end
