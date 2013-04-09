module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class SagePayGateway 
      
      
      
      def complete_3ds(md, parres, options = {})
        raise ArgumentError.new("Missing required parameter: MD") unless md
        raise ArgumentError.new("Missing required parameter: PARes") unless pares
        post = {:md => md, :pares => parres}
        
        commit(:purchase, post)
      end
      
      private
       def build_url(action)
        endpoint = [ :purchase, :authorization ].include?(action) ? "direct3dcallback" : TRANSACTIONS[action].downcase
        puts  "#{test? ? self.test_url : self.live_url}/#{endpoint}.vsp"
        "#{test? ? self.test_url : self.live_url}/#{endpoint}.vsp"
        

      end
    end  
  end  
end  
