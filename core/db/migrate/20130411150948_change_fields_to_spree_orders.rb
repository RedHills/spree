class ChangeFieldsToSpreeOrders < ActiveRecord::Migration
def up
    change_column :spree_orders, :pareq, :text
end
def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :spree_orders, :pareq, :string
end
end
