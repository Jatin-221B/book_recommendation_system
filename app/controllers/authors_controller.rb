class AuthorsController < ApplicationController
  def index
    @authors = Author.includes(:books).order(:name).page(params[:page]).per(9)
  end

  def show
    @author = Author.find_by(id: params[:id])
    if !@author.nil?
      @books = @author.books.order(:title).page(params[:page]).per(9)
    end
  end
end
