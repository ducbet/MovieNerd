class AddPaidToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :paid, :integer, default: 1
  end
end
