class Add3dFieldsToSpreeOrders < ActiveRecord::Migration
  def up
    add_column :spree_orders, :acs_url, :string
    add_column :spree_orders, :pareq, :string    
  end

  def down
  end
end
