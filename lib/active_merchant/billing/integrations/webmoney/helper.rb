module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Webmoney
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @md5secret = options.delete(:secret)
            
            super
          end

          def form_fields
            @md5_secret ? 
              @fields.merge(ActiveMerchant::Billing::Integrations::Webmoney.signature_parameter_name => generate_signature) :
              @fields
          end
            
          def generate_signature_string
            #main_params = [:account, :amount, :order, :currency, :custom_fields].map {|key| @fields[mappings[key]]}
            main_params = [:account, :amount, :order, :test_mode, :description ].map {|key| @fields[mappings[key]]}
            [main_params, @md5secret].flatten.join(':')
          end
          
          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string).upcase
          end
          
          # Replace with the real mapping
          mapping :account, 'LMI_PAYEE_PURSE'
          mapping :amount, 'LMI_PAYMENT_AMOUNT'
        
          mapping :order, 'LMI_PAYMENT_NO'
          mapping :test_mode, 'LMI_SIM_MODE',
          mapping :description, 'LMI_PAYMENT_DESC'
          #mapping :currency, 'ik_paysystem_alias'

          mapping :notify_url, 'LMI_RESULT_URL'
          mapping :return_url, 'LMI_SUCCESS_URL'
          mapping :cancel_return_url, 'LMI_FAIL_URL'
          mapping :return_url_method, 'LMI_SUCCESS_METHOD'
          mapping :cancel_return_url_method, 'LMI_FAIL_METHOD'
          
          #mapping :custom_fields, 'FIELD_'
        end
      end
    end
  end
end
