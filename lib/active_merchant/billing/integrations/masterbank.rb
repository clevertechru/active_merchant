module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:

      module Masterbank 
        autoload :Helper, File.dirname(__FILE__) + '/masterbank/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/masterbank/notification.rb'
        autoload :Return, File.dirname(__FILE__) + '/masterbank/return.rb'

       
        mattr_accessor :service_url
        self.service_url = 'https://web3ds.masterbank.ru/cgi-bin/cgi_link'

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
