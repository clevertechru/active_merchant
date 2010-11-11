module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Qiwi2
        autoload :Notification, File.dirname(__FILE__) + '/qiwi2/notification.rb'

        #mattr_accessor :signature_parameter_name
        #self.signature_parameter_name = 'CheckValue'

        def self.notification(query_string, options = {})
          Notification.new(query_string, options)
        end
      end
    end
  end
end
