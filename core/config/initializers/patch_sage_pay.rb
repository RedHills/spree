
module Spree
  class Gateway::SagePay < Gateway
      include ActiveMerchant::PostsData 
    preference :login, :string
    preference :password, :string
    preference :account, :string
    
    attr_accessible :preferred_login, :preferred_password, :preferred_account
      def complete_3ds (md,pares)

        post = "MD=#{md}&PARes=#{pares}"
        commit_3ds(:callback, post)
      end
      def provider_class
      ActiveMerchant::Billing::SagePayGateway
    end

      private 
  
        def commit_3ds(action, parameters)
        response = parse( ssl_post(build_3ds_url(action), parameters) )
ActiveMerchant::Billing::Response.new(response["Status"] == 'OK', message_from(response), response,
          :test => test?,
          :authorization => authorization_from(response, parameters, action),
          
          :cvv_result => response["CV2Result"]
        )        
        end     
   def authorization_from(response, params, action)
         [ "",
           response["VPSTxId"],
           response["TxAuthNo"],
           response["SecurityKey"],
           action ].join(";") unless response.empty?
      end
      

      def message_from(response)
        response['Status'] == 'OK' ? 'Success' : (response['StatusDetail'] || 'Unspecified error')    # simonr 20080207 can't actually get non-nil blanks, so this is shorter^M
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
      
      
      def parse(body)
        result = {}
        body.to_s.each_line do |pair|
          result[$1] = $2 if pair.strip =~ /\A([^=]+)=(.+)\Z/im
        end
        result
      end
    end
end      
