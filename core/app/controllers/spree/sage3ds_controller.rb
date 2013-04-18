module Spree
  class Sage3dsController < ApplicationController
    include SslRequirement
    ssl_required  
    protect_from_forgery :except => :callback_3dsecure
    respond_to :html
    
    def callback_3dsecure
   
        if params[:MD] && params[:PaRes]  
          base = Rails.env.development? ? "http://localhost/" : "https://#{request.host}/"
          order=Order.by_md(params[:MD])
          order.save!
          #Call sage with md and pares
          logger.info "About to call process_3ds"
          begin          
            response = order.process_3ds( params[:MD] , params[:PaRes])
            if response.success? 
              order.pareq=''
              order.sage_vpstxid=response.params["VPSTxId"] 
              order.sage_txauthcode=response.params["TxAuthNo"]
              order.save!
              order.complete_3d_secure!             
              @url = "#{base}orders/#{order.number}"
              respond_with(@url)     
            end 
            
          rescue Core::GatewayError => ge
            logger.info "3d failed by provider"            
            order.fail_3d_secure!
            order.get_3dpending_payment.fail_3d! if order.get_3dpending_payment
            current_order=nil
            @url = "#{base}cart?threed=0"
      
            respond_with(@url)                
          end          

        else
          logger.error("Callback for 3d Secure missing params")
          raise ActionController::RoutingError.new('Not Found')

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
