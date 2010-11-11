module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Qiwi2
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def self.recognizes?(params)
            params.has_key?('txn_id')
          end

          def complete?
            status == 'pay'
          end

          def check?
            status == 'check'
          end

          def amount
            BigDecimal.new(gross)
          end

          def item_id
            params['account']
          end

          def transaction_id
            params['txn_id']
          end

          def received_at
            params['txn_date']
          end

          def gross
            params['sum']
          end

          def status
            params['command']
          end

          def content_id
            params['content_id']
          end

          def acknowledge
            # TODO: request IP-address check
            true
          end

          def response_content_type
            'application/xml'
          end

          @@response_codes = {:fatal_error => 300, :error => 1, :ok => 0}

          def response(response_code, options = {})
            @billing_payment = options[:payment]
            <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<response>
  <osmp_txn_id>#{transaction_id}</osmp_txn_id>
  <prv_txn>#{@billing_payment.id if @billing_payment}</prv_txn>
  <sum>#{@billing_payment.amount if @billing_payment}</sum>
  <result>#{response_code}</result>
  <comment>#{options[:description]}</comment>
</response>
            XML
          end

          def success_response(options = {})
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
