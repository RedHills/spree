module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class SagePayGateway 
      def self.set_callback_url(url)
        @callback_url=url
      end        
      
      def self.get_callback_url()
        @callback_url
      end        

    def complete_3ds (md,pares)

        post = "MD=#{md}&PARes=#{pares}"
        commit_3ds(:callback, post)
      end
    
   
      private 
  
        def commit_3ds(action, parameters)
        response = parse( ssl_post(build_3ds_url(action), parameters) )
        formatted_resp =ActiveMerchant::Billing::Response.new(response["Status"] == 'OK', message_from(response), response,
          :test => test?,
          :authorization => authorization_from(response, parameters, action),
          
          :cvv_result => response["CV2Result"]
        )
        formatted_resp        
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
end  

      
