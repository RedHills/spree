module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class SagePayGateway 
      def self.set_callback_url(url)
        @callback_url=url
      end        
      
      def self.get_callback_url()
        @callback_url
      end        


   

      
      
      private
       def build_3ds_url(action)
        endpoint = [ :purchase, :authorization ].include?(action) ? "direct3dcallback" : TRANSACTIONS[action].downcase
        puts  "#{test? ? self.test_url : self.live_url}/#{endpoint}.vsp"
        "#{test? ? self.test_url : self.live_url}/#{endpoint}.vsp"
      end      
      
      def get_callback_url
        raise(ArgumentError, "Callback URL not initialised") unless Spree::Config[:callback_url]
        Spree::Config[:callback_url]
      end  
     
     
    end  
  end  
end  

      
