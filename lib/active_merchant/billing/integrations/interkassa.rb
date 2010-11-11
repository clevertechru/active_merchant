module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:

      # Documentation: http://www.interkassa.com/docs/interkassa.tech.doc
      module Interkassa 
        autoload :Helper, File.dirname(__FILE__) + '/interkassa/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/interkassa/notification.rb'
        autoload :Return, File.dirname(__FILE__) + '/interkassa/return.rb'
       
        mattr_accessor :service_url
        self.service_url = 'http://www.interkassa.com/lib/payment.php'

        mattr_accessor :signature_parameter_name
        self.signature_parameter_name = 'ik_sign_hash'

        def self.helper(order, account, options = {})
          Helper.new(order, account, options)
        end

        def self.notification(query_string, options = {})
          Notification.new(query_string, options)
        end  
        
        def self.return(query_string)
          Return.new(query_string)
        end
      end
    end
  end
end
