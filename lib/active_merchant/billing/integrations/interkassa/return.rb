module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Interkassa
        class Return < ActiveMerchant::Billing::Integrations::Return
          def success?
            status == 'success'
          end
          
          def status
            params['ik_payment_state']
          end
          
          def account
            params['ik_shop_id']
          end
          
          def item_id
            params['ik_payment_id']
          end
          
          def currency
            params['ik_paysystem_alias']
          end
          
          def custom_fields
            params['ik_baggage_fields']
          end
          
          def transaction_id
            params['ik_trans_id']
          end

          def received_at
            params['ik_payment_timestamp']
          end
	      end
      end
    end
  end
end
