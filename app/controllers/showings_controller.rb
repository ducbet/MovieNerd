class ShowingsController < ApplicationController
  def index
    @movies = Movie.showing.page(params[:page]).per_page Settings.admin.per_page
  end
end
