module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Premium
        autoload :Notification, File.dirname(__FILE__) + '/premium/notification.rb'

        mattr_accessor :signature_parameter_name
        self.signature_parameter_name = 'skey'
        

        def self.notification(query_string, options = {})
          Notification.new(query_string, options)
        end
      end
    end
  end
end
