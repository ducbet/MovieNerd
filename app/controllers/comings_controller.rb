class ComingsController < ApplicationController
  def index
    @movies = Movie.coming.page(params[:page]).per_page Settings.admin.per_page
  end
end
