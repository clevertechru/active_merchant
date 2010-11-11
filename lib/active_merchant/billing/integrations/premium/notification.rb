module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Premium
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('msg') && params.has_key?('user_id') && params.has_key?('skey')
          end

          def complete?
            status == 'success'
          end

          def transaction_id
            params['id']
          end

          def gross
            params['cost']
          end

          def amount
            BigDecimal.new(gross)
          end

          def short_number
            params['num']
          end

          def item_id
            msg = params['msg']
            prefixes = @options[:operators].map {|operator, config| config['prefix']}.uniq
            prefixes.each do |prefix|
              if msg.starts_with?(prefix)
                return msg.sub(prefix, '').strip
              end
            end
            return nil
          end

          def received_at
            params['date']
          end

          def phone
            params['user_id']
          end

          def status
            'success'
          end

          def security_key
            params[ActiveMerchant::Billing::Integrations::Premium.signature_parameter_name]
          end

          def generate_signature_string
            [transaction_id, received_at, @options[:secret]].flatten.compact.join('')
          end

          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string)
          end

          def acknowledge
            Rails.logger.info("#{security_key} =? #{generate_signature}")
            security_key == generate_signature
          end

          def response_content_type
            'application/xml'
          end

          @@response_codes = {:fatal_error => 2, :error => 1, :ok => 0}

          def response(response_code, options = {})
            answer = options[:answer] || options[:payment].try(:answer) || ""
            <<-XML
<?xml version="1.0" encoding="UTF-8" ?>
<response>
  <result>#{response_code}</result>
  <answer>#{answer}</answer>
</response>
            XML
          end

          def success_response(options = {}, *args)
            response(@@response_codes[:ok], options)
          end

          def error_response(error_type, options = {})
            response(@@response_codes[error_type], options)
          end
        end
      end
    end
  end
end
