module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Masterbank
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('RRN') && params.has_key?('IntR')
          end

          def complete?
            status == '0'
          end

          def amount
            BigDecimal.new(gross)
          end

          def item_id
            params['Order']
          end

          def transaction_id
            params['RRN']
          end

          def currency
            params['Currency']
          end

          def status
            params['Result']
          end

          # the money amount we received in X.2 decimal.
          def gross
            params['Amount']
          end

          def response_content_type
            'text/plain'
          end
          
          def acknowledge
            true
          end

          def success_response(*args)
            "OK"
          end

          def error_response(error_type, options = {})
            "ERROR"
          end
          
        end
      end
    end
  end
end
