module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Assist
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('OrderNumber') && params.has_key?('Shop_IDP')
          end

          def complete?
            status == 'AS000'
          end

          def account
            params['Shop_IDP']
          end

          def amount
            BigDecimal.new(gross)
          end

          def item_id
            params['OrderNumber']
          end

          def transaction_id
            params['BillNumber']
          end

          def received_at
            params['Date']
          end

          def security_key
            params[ActiveMerchant::Billing::Integrations::Assist.signature_parameter_name]
          end

          def currency
            params['Currency']
          end

          def status
            params['Response_Code']
          end

          # the money amount we received in X.2 decimal.
          def gross
            params['Total']
          end

          def generate_signature_string
            [account, item_id, gross, currency, @options[:secret]].flatten.compact.join('')
          end

          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string).upcase
          end

          def acknowledge
            security_key == generate_signature
          end

          def response_content_type
            'application/xml'
          end

          def success_response(*args)
            <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<pushpaymentresult firstcode="0" secondcode="0">
<order>
  <billnumber>#{item_id}</billnumber>
  <packetdate>#{received_at}</packetdate>
</order>
</pushpaymentresult>
            XML
          end

          def error_response(error_type, options = {})
            <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<pushpaymentresult firstcode="0" secondcode="0">
<order>
  <billnumber>#{item_id}</billnumber>
  <packetdate>#{received_at}</packetdate>
</order>
</pushpaymentresult>
            XML
          end
          
        end
      end
    end
  end
end
