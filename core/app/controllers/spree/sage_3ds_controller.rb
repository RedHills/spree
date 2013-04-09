module Spree
  class Sage3dsController < ApplicationController
    
    ssl_required  
    protect_from_forgery :except => :callback_3dsecure
    respond_to :html
    
    def callback_3dsecure
       respond_with do |format|
        format.html { render :layout => false }
      end
    end  
    
    def complete_3dsecure(params)
      params["VendorTxCode"] = checkout.order.vtx_code
      response = payment_gateway.complete_3dsecure(params)
      gateway_error(response) unless response.success?          

      txn = CreditcardTxn.find_by_md(params["MD"])
      txn.response_code = response.authorization
      txn.save
    end    
  end
end
