module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Assist
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @md5secret = options.delete(:secret)
            @payment_methods = options.delete(:payments)
            super
          end
          
          def form_fields
            @fields.merge(payment_method_fields)
          end
          
          def payment_method_fields
            return {} unless @payment_methods
            fields = {}
            fields["CardPayment"] = @payment_methods.include?(:card) ? "1" : "0"
            fields["AssistIDCCPayment"] = @payment_methods.include?(:assist) ? "1" : "0"
            fields["PayCashPayment"] = @payment_methods.include?(:cash) ? "1" : "0"
            fields["WebMoneyPayment"] = @payment_methods.include?(:webmoney) ? "1" : "0"
            fields["EPBeelinePayment"] = @payment_methods.include?(:beeline) ? "1" : "0"
            fields
          end

          mapping :account, 'Shop_IDP'
          mapping :amount, 'Subtotal_P'
          mapping :currency, 'Currency'
          mapping :order, 'Order_IDP'
          mapping :description, 'Comment'

          mapping :notify_url, 'URL_RETURN'
          mapping :return_url, 'URL_RETURN_OK'
          mapping :cancel_return_url, 'URL_RETURN_NO'
          
          mapping :first_name, 'FirstName'
          mapping :last_name, 'LastName'
          mapping :email, 'Email'
        end
      end
    end
  end
end
