module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Webmoney
        class Return < ActiveMerchant::Billing::Integrations::Return
          def success?
            true
          end
          
          def status
            #params['LMI_']
          end
          
          def account
            params['LMI_PAYEE_PURSE']
          end
          
          def item_id
            params['LMI_PAYMENT_NO']
          end
          
          #def currency
          #  params['LMI']
          #end
          #
          #def custom_fields
          #  params['FIELD_']
          #end
          
          def transaction_id
            params['LMI_SYS_TRANS_NO']
          end

          def received_at
            params['LMI_SYS_TRANS_DATE']
          end
	      end
      end
    end
  end
end
