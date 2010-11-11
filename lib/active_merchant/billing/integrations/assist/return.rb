module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Assist
        class Return < ActiveMerchant::Billing::Integrations::Return
          def item_id
            params['order_idp']
          end
	      end
      end
    end
  end
end
