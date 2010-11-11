module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Beeline
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('order') && params.has_key?('sum')
          end

          def complete?
            status == 'success'
          end

          def transaction_id
            params['id']
          end

          def gross
            params['sum']
          end

          def amount
            BigDecimal.new(gross)
          end

          def item_id
            params['order']
          end

          def received_at
            params['datetime']
          end

          def phone
            params['phone']
          end

          def status
            'success'
          end

          def security_key
            params[ActiveMerchant::Billing::Integrations::Beeline.signature_parameter_name]
          end

          def generate_signature_string
            [transaction_id, @options[:secret], phone, item_id, gross, received_at].flatten.compact.join('')
          end

          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string)
          end

          def acknowledge
            security_key == generate_signature
          end

          def response_content_type
            'application/xml'
          end

          @@response_codes = {:fatal_error => 2, :error => 1, :ok => 0}

          def response(response_code, options = {})
            answer = options[:answer] || options[:payment].try(:answer) || ""
            description = answer.blank? ? '' : "<description>#{answer}</description>"
            <<-XML
<?xml version="1.0" encoding="UTF-8" ?>
<response> 
  <result>#{response_code}</result>
  #{description}
</response>
            XML
          end

          def success_response(options = {}, *args)
            response(@@response_codes[:ok], options, *args)
          end

          def error_response(error_type, options = {})
            response(@@response_codes[error_type], options)
          end
        end
      end
    end
  end
end
