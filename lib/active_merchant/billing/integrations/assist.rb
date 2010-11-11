module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:

      # Documentation: http://assist.ru/support_center/setup/mode2.htm

      module Assist 
        autoload :Helper, File.dirname(__FILE__) + '/assist/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/assist/notification.rb'
        autoload :Return, File.dirname(__FILE__) + '/assist/return.rb'

       
        mattr_accessor :service_url
        self.service_url = 'https://secure5.assist.ru/shops/cardpayment.cfm'

        mattr_accessor :signature_parameter_name
        self.signature_parameter_name = 'CheckValue'

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
