class AcceptsController < ApplicationController
  def index
    @order = Order.find_by id: params[:id]
    if @order.present? && current_user == @order.user
      @order.paid!
      redirect_to order_url(order.id)
    else
      flash[:danger] = "Khong ton tai order nay"
      redirect_to root_url
    end
  end
end
