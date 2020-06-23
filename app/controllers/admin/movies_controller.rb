class Admin::MoviesController < Admin::BaseController
  before_action :find_movie, only: [:show, :edit, :update, :destroy]
  before_action :load_keys, only: [:new, :create, :edit, :update]

  def index
    @movies = Movie.page(params[:page])
                   .per Settings.admin.per_page
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new movie_params

    if @movie.save
      redirect_to admin_movie_path @movie
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @movie.update_attributes movie_params
      flash[:success] = t "flash.movie_update_success"
      redirect_to admin_movie_path @movie
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
    flash[:success] = t "flash.movie_delete_success"
    redirect_to admin_movies_path
  end

  private

  def find_movie
    @movie = Movie.find_by id: params[:id]

    return if @movie
    flash[:danger] = t "flash.no_movie"
    redirect_to admin_movies_path
  end

  def load_keys
    @keys = Movie.rateds.keys
  end

  def movie_params
    params.require(:movie).permit :title, :cast, :director, :description,
      :duration, :rated, :language, :genre,
      :release_date, :picture, :trailer_url
  end
end
