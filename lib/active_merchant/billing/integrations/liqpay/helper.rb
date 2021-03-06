module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Liqpay
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @secret = options.delete(:secret)
            super

            add_field 'version', '1.2'
          end
          
          def form_fields
            xml = "<request>      
          		<version>1.2</version>
          		<result_url>#{@fields.delete("result_url")}</result_url>
          		<server_url>#{@fields.delete("server_url")}</server_url>
          		<merchant_id>#{@fields.delete("merchant_id")}</merchant_id>
          		<order_id>#{@fields.delete("order_id")}</order_id>
          		<amount>#{@fields.delete("amount")}</amount>
          		<currency>#{@fields.delete("currency")}</currency>
          		<description>#{@fields.delete("description")}</description>
          		<default_phone>#{@fields.delete("default_phone")}</default_phone>
          		<pay_way>card</pay_way> 
          		</request>".strip
            sign = Base64.encode64(Digest::SHA1.digest("#{@secret}#{xml}#{@secret}")).strip
            {"operation_xml" => Base64.encode64(xml), "signature" => sign}
          end

          mapping :account, 'merchant_id'
          mapping :amount, 'amount'
          mapping :currency, 'currency'
          mapping :order, 'order_id'
          mapping :description, 'description'
          mapping :phone, 'default_phone'

          mapping :notify_url, 'server_url'
          mapping :return_url, 'result_url'
        end
      end
    end
  end
end
