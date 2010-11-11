module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Robokassa
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @md5secret = options.delete(:secret)
            super
          end

          def form_fields
            @fields.merge(ActiveMerchant::Billing::Integrations::Robokassa.signature_parameter_name => generate_signature)
          end
            
          def generate_signature_string
            main_params = [:account, :amount, :order].map {|key| @fields[mappings[key]]}
            custom_param_keys = @fields.keys.select {|key| key.to_s =~ /^shp/}.sort
            custom_params = custom_param_keys.map {|key| "#{key}=#{@fields[key.to_s]}"}
            [main_params, @md5secret, custom_params].flatten.compact.join(':')
          end
          
          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string)
          end

          def method_missing(method_id, *args)
            method_id = method_id.to_s.gsub(/=$/, '')
            
            # support for robokassa custom parameters
            if method_id =~ /^shp/
              add_field method_id, args.last
            end
            super
          end
          

          mapping :account, 'MrchLogin'
          mapping :amount, 'OutSum'
          mapping :currency, 'IncCurrLabel'
          mapping :order, 'InvId'
          mapping :description, 'Desc'
          mapping :email, 'Email'
        end
      end
    end
  end
end
