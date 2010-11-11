module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Masterbank
        class Return < ActiveMerchant::Billing::Integrations::Return
          def item_id
            params['order_idp']
          end
	      end
      end
    end
  end
end
