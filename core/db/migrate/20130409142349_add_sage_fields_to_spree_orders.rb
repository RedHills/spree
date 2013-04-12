class AddSageFieldsToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sage_security_key, :string
    add_column :spree_orders, :sage_vpstxid, :string
    add_column :spree_orders, :sage_txauthcode, :string
  end
end
