module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Robokassa
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('InvId') && params.has_key?('OutSum')
          end

          def complete?
            true
          end
          
          def amount
            BigDecimal.new(gross)
          end

          def item_id
            params['InvId']
          end

          def security_key
            params[ActiveMerchant::Billing::Integrations::Robokassa.signature_parameter_name].to_s.downcase
          end

          def gross
            params['OutSum']
          end

          def status
            'success'
          end

          def generate_signature_string
            main_params = [gross, item_id]
            custom_param_keys = params.keys.select {|key| key =~ /^shp/}.sort
            custom_params = custom_param_keys.map {|key| "#{key}=#{params[key]}"}
            [main_params, @options[:secret], custom_params].flatten.compact.join(':')
          end
          
          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string)
          end

          def acknowledge    
            security_key == generate_signature
          end
          
          def success_response(*args)
            "OK#{item_id}"
          end
        end
      end
    end
  end
end
