module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      
      # Documentation: http://robokassa.ru/Doc/En/Interface.aspx
      module Robokassa 
        autoload :Helper, File.dirname(__FILE__) + '/robokassa/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/robokassa/notification.rb'
        autoload :Return, File.dirname(__FILE__) + '/robokassa/return.rb'
        
        mattr_accessor :service_url
        self.service_url = 'https://merchant.roboxchange.com/Index.aspx'

        mattr_accessor :signature_parameter_name
        self.signature_parameter_name = 'SignatureValue'


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
