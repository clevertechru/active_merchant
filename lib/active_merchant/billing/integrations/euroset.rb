module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      
      module Euroset 
        autoload :Notification, File.dirname(__FILE__) + '/euroset/notification.rb'
        
       
        def self.notification(query_string, options = {})
          Notification.new(query_string, options)
        end  
      end
    end
  end
end
