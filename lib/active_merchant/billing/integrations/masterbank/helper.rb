module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Masterbank
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @secret = options.delete(:secret)
            @payment_methods = options.delete(:payments)
            @account = account
            super
          end
          
          def form_fields
            @fields.merge(payment_method_fields)
          end
          
          def payment_method_fields
            fields = {}
            fields["MERC_GMT"] = "#{Time.now.gmt_offset / 3600}"
            fields["TIMESTAMP"] = Time.now.utc.strftime("%Y%m%d%H%M%S")
            fields[mappings[:terminal]] = @secret
            fields[mappings[:account]] = @account
            fields
          end

          mapping :amount, 'AMOUNT'
          mapping :currency, 'CURRENCY'
          mapping :order, 'ORDER'
          mapping :description, 'DESC'
          mapping :account_name, 'MERCH_NAME'
          mapping :return_url, 'MERCH_URL'
          mapping :account, 'MERCHANT'
          mapping :terminal, 'TERMINAL'
          mapping :transaction_type, 'TRTYPE'
          mapping :gmt_offset, 'MERC_GMT'
          mapping :timestamp, "TIMESTAMP"
          mapping :notify_url, 'BACKREF'
          

          mapping :cancel_return_url, 'URL_RETURN_NO'
          
          mapping :first_name, 'FirstName'
          mapping :last_name, 'LastName'
          mapping :email, 'Email'
        end
      end
    end
  end
end
