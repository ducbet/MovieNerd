class RoomsController < ApplicationController
  before_action :logged_in_user, only: [:show]
  before_action :load_support, only: [:show]

  def show
    @order = Order.new
    @selected_seats = []
  end

  private

  def load_support
    screening = Screening.find_by id: screening_id
    redirect_to root_url unless params[:id] == screening.room_id.to_s

    @support = RoomSupport.new screening
  end

  def screening_id
    params.require :screening_id
  end
end
