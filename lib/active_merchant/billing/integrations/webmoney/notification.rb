module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Webmoney
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('LMI_PAYMENT_AMOUNT') && params.has_key?('LMI_PAYMENT_NO')
          end

          def complete?
            true
          end

          def pre_request
            params.has_key?('LMI_PREREQUEST') && params['LMI_PREREQUEST'].to_i==1
          end

          def account
            params['LMI_PAYEE_PURSE']
          end

          def amount
            BigDecimal.new(gross)
          end
          
          def item_id
            params['LMI_PAYMENT_NO']
          end

          def invoice_id
            params['LMI_SYS_INVS_NO']
          end

          def transaction_id
            params['LMI_SYS_TRANS_NO']
          end

          def received_at
            params['LMI_SYS_TRANS_DATE']
          end

          def security_key
            params[ActiveMerchant::Billing::Integrations::Webmoney.signature_parameter_name]
          end
          
          def custom_fields
            #params['FIELD_']
          end
          
          #def currency
          #  params['LMI_']
          #end
          #
          #def status
          #  params['LMI_']
          #end

          def payer_purse
            params['LMI_PAYER_PURSE']
          end

          def payer_wm
            params['LMI_PAYER_WM']
          end

          def test_mode
            params['LMI_MODE']
          end

          # the money amount we received in X.2 decimal.
          def gross
            params['LMI_PAYMENT_AMOUNT']
          end

          def generate_signature_string
            [account, gross, item_id, test_mode, invoice_id, transaction_id, received_at, @options[:secret], payer_purse, payer_wm ].flatten.join
          end

          #def generate_signature_string
          #  [account, gross, item_id, currency, custom_fields, status, transaction_id, exchange, fees_payer, @options[:secret]].flatten.join(':')
          #end
          
          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string).upcase
          end

          def acknowledge
            return true if pre_request
            security_key == generate_signature
          end

          def success_response(*args)
            "YES"
          end

        end
      end
    end
  end
end
