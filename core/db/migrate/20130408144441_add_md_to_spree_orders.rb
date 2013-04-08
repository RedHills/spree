class AddMdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :md, :string
  end
end
