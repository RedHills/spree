module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class SagePayGateway 
      
      private
       def build_url(action)
        endpoint = [ :purchase, :authorization ].include?(action) ? "direct3dcallback" : TRANSACTIONS[action].downcase
        "#{test? ? self.test_url : self.live_url}/#{endpoint}.vsp"
      end
    end  
  end  
end  
