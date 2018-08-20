class FailsController < ApplicationController
  def index
    @order = Order.find_by id: params[:order_id]
    if @order.present? && current_user == @order.user
      @order.destroy
      redirect_to root_url
    else
      redirect_to root_url
    end
  end
end
