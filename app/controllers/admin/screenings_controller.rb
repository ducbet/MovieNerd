class Admin::ScreeningsController < Admin::BaseController
  before_action :load_support, only: [:new, :edit, :create]

  def index
    @screenings = Screening.not_show_yet.page(params[:page])
                           .per_page Settings.admin.per_page
  end

  def new
    @screening = Screening.new
    respond_to do |format|
      format.html
      format.js{render "admin/screenings/filter_screening"}
    end
  end

  def create
    @screening = Screening.new screenings_params
    movie = @screening.movie

    if @screening.save
      redirect_to admin_movie_path movie
    else
      render :new
    end
  end

  def destroy
    @screening = Screening.find_by id: params[:id]
    movie = if params[:movie_id]
              Movie.find_by id: params[:movie_id]
            else
              @screening.movie
            end
    @screening.destroy
    flash[:success] = t "flash.screening_delete_success"
    redirect_to admin_movie_path movie
  end

  private

  def screenings_params
    params.require(:screening).permit :screening_start, :movie_id, :room_id
  end

  def load_support
    room = Room.find_by id: params[:screening][:room_id] if params[:screening]
    @support = ScreeningSupport.new find_movie, room
  end

  def find_movie
    movie = if params[:movie_id]
              Movie.find_by id: params[:movie_id]
            elsif params[:screening]
              Movie.find_by id: params[:screening][:movie_id]
            end

    return movie if movie
    flash[:danger] = t "flash.no_movie"
    redirect_to admin_movies_path
  end
end
