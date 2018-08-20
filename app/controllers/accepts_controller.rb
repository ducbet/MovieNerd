class AcceptsController < ApplicationController
  def index
    @order = Order.find_by id: params[:id]
    if @order.present? && current_user == @order.user
      @order.paid!
      redirect_to order_url(order.id)
    else
      flash[:danger] = t "flash.no_order"
      redirect_to root_url
    end
  end
end
