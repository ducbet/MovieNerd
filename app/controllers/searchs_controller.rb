class SearchsController < ApplicationController
  before_action :find_keyword

  def index
    @movies = search_movies @keyword
  end

  def create
    @movies = search_movies @keyword
    render "searchs/index"
  end

  private

  def find_keyword
    @keyword = params[:keyword]
  end

  def search_movies keyword
    if params[:keyword].nil?
      Movie.page(params[:page]).per Settings.admin.per_page
    else
      Movie.full_text_search(keyword)
           .page(params[:page])
           .per Settings.admin.per_page
    end
  end
end
