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
          logger.info "About to call process_3ds"
          response = order.process_3ds( params[:MD] , params[:PARes])
          logger.info "Response #{response.to_s}"
          if !response.empty? && response[:status]=='OK'
            order.sage_vpstxid=response[:VPSTxId] 
            order.sage_sage_txauthcode=response[:TxAuthNo]
            flash.notice = t(:order_processed_successfully)
            order.save!
            order.complete_3d_secure!             
            logger.info "3d >>>> order set to complete"            
            @url = "#{request.host_with_port}/checkout/payment"            
          else
             logger.info "3d failed by provider"            
            flash.error = "Order failed 3D Secure Check"      
             order.fail_3d_secure!
           
             order.get_3dpending_payment.fail_3d! if order.get_3dpending_payment
          @url = order_path(order)              
          end 

        else
          logger.error("Callback for 3d Secure missing params")

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
