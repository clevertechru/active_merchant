require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Beeline
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @secret = options.delete(:secret)
            super
            add_field(:dt, Time.now.strftime('%Y%m%d%H%M%S'))
            add_field(:cmd, 'create')
          end

          def form_fields
            returning @fields.merge("cs" => generate_signature) do |fields|
              fields.delete(mappings[:account])
            end
          end

          def generate_signature_string
            [@fields['dt'], @secret, @fields[mappings[:order]], @fields[mappings[:amount]]].flatten.compact.join(':')
          end

          def generate_signature
            Digest::MD5.hexdigest(generate_signature_string)
          end

          def full_service_url
            "#{ActiveMerchant::Billing::Integrations::Beeline.service_url}/#{@fields[mappings[:account]]}"
          end

          def announce_invoice
            response = Net::HTTP.post_form(URI.parse(full_service_url), form_fields)
            return ['0', '3'].include?(response.body)
          end

          mapping :account, 'account'

          mapping :order, 'ic'
          mapping :amount, 'os'
          mapping :answer, 'an'
        end
      end
    end
  end
end
