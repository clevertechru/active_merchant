module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Interkassa
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('ik_payment_amount') && params.has_key?('ik_payment_id')
          end

          def complete?
            status == 'success'
          end 

          def account
            params['ik_shop_id']
          end

          def amount
            BigDecimal.new(gross)
          end
          
          def item_id
            params['ik_payment_id']
          end

          def transaction_id
            params['ik_trans_id']
          end

          def received_at
            params['ik_payment_timestamp']
          end

          def security_key
            params[ActiveMerchant::Billing::Integrations::Interkassa.signature_parameter_name]
          end
          
          def custom_fields
            params['ik_baggage_fields']
          end
          
          def currency
            params['ik_paysystem_alias']
          end
          
          def status
            params['ik_payment_state']
          end
          
          def exchange
            params['ik_currency_exch']
          end
          
          def fees_payer
            params['ik_fees_payer']
          end

          # the money amount we received in X.2 decimal.
          def gross
            params['ik_payment_amount']
          end

          def generate_signature_string
            [account, gross, item_id, currency, custom_fields, status, transaction_id, exchange, fees_payer, @options[:secret]].flatten.join(':')
          end
          
          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string).upcase
          end

          def acknowledge      
            security_key == generate_signature
          end
        end
      end
    end
  end
end
