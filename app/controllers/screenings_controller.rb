class ScreeningsController < ApplicationController
  before_action :load_support, only: [:index]

  def index; end

  private

  def load_support
    movie = Movie.find_by id: params[:id]
    @support = ScreeningSupport.new movie
  end
end
