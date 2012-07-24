module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      # Documentation: https://wiki.webmoney.ru/projects/webmoney/wiki/Web_Merchant_Interface
      module Webmoney
        autoload :Helper, File.dirname(__FILE__) + '/webmoney/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/webmoney/notification.rb'
        autoload :Return, File.dirname(__FILE__) + '/webmoney/return.rb'
       
        mattr_accessor :service_url
        self.service_url = 'https://merchant.webmoney.ru/lmi/payment.asp'

        mattr_accessor :signature_parameter_name
        self.signature_parameter_name = 'LMI_HASH'

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
