class OrdersController < ApplicationController
  before_action :correct_order, only: [:show]

  def index
    @order = Order.find_by(id: params[:id])
                  .page(params[:page]).per_page Settings.admin.per_page
  end

  def show; end

  def create
    user = current_user
    screening = Screening.find_by id: params[:screening_id]
    room = Room.find_by id: params[:room_id]

    ActiveRecord::Base.transaction do
      order = user.orders.create! screening_id: screening.id
      # rake jobs:work
      order.delete_unpaid
      raise ActiveRecord::RecordInvalid if params_selected_seats.empty?
      params_selected_seats.each do |seat_name|
        row, num = seat_name.split "_"
        seat = room.seats.find_by row: row, number: num
        order.movie_tickets.create! seat_id: seat.id, screening_id: params[:screening_id]
      end
      order.paid!
      redirect_to order_url(order.id)
      # redirect_to baokim(screening.movie.title, screening.movie.id,
      #   params_selected_seats.count, order.id)
    end
    rescue
      load_support screening
      @selected_seats = params_selected_seats - @support.sold
      flash.now[:danger] = t "flash.select_seat_failed"
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def load_support screening
    @support = RoomSupport.new screening
  end

  def screening_id
    params.require :screening_id
  end

  def params_selected_seats
    return [] if params[:selected_seats].nil?
    params[:selected_seats].split ","
  end

  def correct_order
    @order = Order.find_by id: params[:id]
    unless current_user == @order.user
      flash[:danger] = t "flash.invalid_order"
      redirect_to root_url
    end
    if @order.paid == "unpaid"
      flash[:danger] = t "flash.unpaid_order"
      redirect_to root_url
    end
  end

  def baokim(product_name, detail_movie, product_quantity, order_id)
    business = "trieuduc1996%40gmail.com"
    order_description = ""
    product_price = 10000
    total_amount = product_price * product_quantity
    # url_detail = "https%3A%2F%2Fmovie-nerd.herokuapp.com%2Fmovies%2F#{detail_movie}"
    # url_cancel = "https%3A%2F%2Fmovie-nerd.herokuapp.com%2Fvi%2Fabout"
    # url_success = "https%3A%2F%2Fmovie-nerd.herokuapp.com%2Fvi%2Fmovies%2F5"
    url_success = "http%3A%2F%2F0.0.0.0%3A3000%2Faccepts%2F#{order_id}"
    url_detail = "http%3A%2F%2F0.0.0.0%3A3000%2Fmovies%2F#{detail_movie}"
    url_cancel = "http%3A%2F%2F0.0.0.0%3A3000%2F"

    url = "https://www.baokim.vn/payment/product/version11?business=#{business}&id=&order_description=#{order_description}&product_name=#{product_name}&product_price=#{product_price}&product_quantity=#{product_quantity}&total_amount=#{total_amount}&url_cancel=#{url_cancel}&url_detail=#{url_detail}&url_success=#{url_success}"
end
