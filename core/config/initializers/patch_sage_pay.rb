module Spree
  class Gateway::SagePay < Gateway
      include ActiveMerchant::PostsData 
    
      def complete_3ds (md,pares)
        post = "MD=#{md}&PARes=#{pares}"
        commit_3ds(:callback, post)
      end
      
      private 
  
        def commit_3ds(action, parameters)
        response = parse( ssl_post(build_3ds_url(action), parameters) )
        response
        end     
      
      def build_3ds_url(action)
        endpoint = [ :callback,:purchase, :authorization ].include?(action) ? "direct3dcallback" : TRANSACTIONS[action].downcase
        puts  "#{test? ? ActiveMerchant::Billing::SagePayGateway.test_url : ActiveMerchant::Billing::SagePayGateway.live_url}/#{endpoint}.vsp"
        "#{test? ? ActiveMerchant::Billing::SagePayGateway.test_url : ActiveMerchant::Billing::SagePayGateway.live_url}/#{endpoint}.vsp"
      end
      
      # A check to see if we're in test mode
      def test?
        Rails.env.development? || Rails.env.test?
      end
    end
end      
