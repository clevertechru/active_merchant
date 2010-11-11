module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Beeline 
        autoload :Helper, File.dirname(__FILE__) + '/beeline/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/beeline/notification.rb'

        mattr_accessor :service_url
        self.service_url = 'http://b2b.m-commerce.ru/store'

        mattr_accessor :signature_parameter_name
        self.signature_parameter_name = 'control'

        def self.helper(order, account, options = {})
          Helper.new(order, account, options)
        end

        def self.notification(query_string, options = {})
          Notification.new(query_string, options)
        end
      end
    end
  end
end
