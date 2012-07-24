module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module W1
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @md5secret = options.delete(:secret)
            
            super
          end

          def form_fields
            @md5_secret ? 
              @fields.merge(ActiveMerchant::Billing::Integrations::W1.signature_parameter_name => generate_signature) :
              @fields
          end
            
          def generate_signature_string
            #main_params = [:account, :amount, :order, :currency].map {|key| @fields[mappings[key]]}
            #main_params.sort
            #[main_params, @md5secret].flatten.join
            fields = @fields.clone
            fields.delete(ActiveMerchant::Billing::Integrations::W1.signature_parameter_name)
            fields = fields.sort
            values = fields.map {|key,val| val}
            signature_string = [values, @md5secret].flatten.join
            encode_string(signature_string,"cp1251")
          end
          
          def generate_signature
            Digest::MD5.base64digest(generate_signature_string)
          end

          def encode_string(data,enc='cp1251')
            if data.respond_to?(:encode!)
              data.encode!('UTF-8', enc)
            else    # for ruby 1.8
              require 'iconv'
              data = Iconv.new('utf-8', enc).iconv(data)
            end
            data
          end
          
          # Replace with the real mapping
          mapping :account, 'WMI_MERCHANT_ID'
          mapping :amount, 'WMI_PAYMENT_AMOUNT'
        
          mapping :order, 'WMI_PAYMENT_NO'
          mapping :currency, 'WMI_CURRENCY_ID'

          #mapping :notify_url, 'result_url'
          mapping :return_url, 'WMI_SUCCESS_URL'
          mapping :cancel_return_url, 'WMI_FAIL_URL'
          mapping :description, 'WMI_DESCRIPTION'
          
          #mapping :custom_fields, 'custom_fields'
        end
      end
    end
  end
end
