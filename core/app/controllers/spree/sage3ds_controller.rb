module Spree
  class Sage3dsController < ApplicationController
    include SslRequirement
    ssl_required  
    protect_from_forgery :except => :callback_3dsecure
    respond_to :html
    
    def callback_3dsecure
        if params[:MD] && params[:PARes]  
          order=Order.by_md(params[:MD])
          order.save!
          #Call sage with md and pares
          response = order.process_3ds( params[:MD] , params[:PARes])
          
          if response[:status]=='OK'
              order.success
              order.get_3dpending_payment.complete
              order.sage_vpstxid=response[:VPSTxId]
              order.sage_sage_txauthcode=response[:TxAuthNo] 
              flash.notice = t(:order_processed_successfully)
              order.save!
              order.complete!             
          else
             flash.notice = t(:order_processed_successfully)
             order.get_3dpending_payment.failure
              
          end 

        else
          logger.error("Callback for 3d Secure missing params")
          #raise Core::GatewayError.new("Callback for 3d Secure missing params")
        end  
    end 
    
  
#    
#    def complete_3dsecure(params)
#      params["VendorTxCode"] = checkout.order.vtx_code
#      response = payment_gateway.complete_3dsecure(params)
#      response) unless response.success?          

#      txn = CreditcardTxn.find_by_md(params["MD"])
#      txn.response_code = response.authorization
#      txn.save
#    end    
  end
end
