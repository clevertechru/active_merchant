require 'test_helper'

class InterkassaNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @interkassa = Interkassa::Notification.new(http_raw_data, :secret => 'secret')
  end

  def test_accessors
    assert @interkassa.complete?
    assert_equal "success", @interkassa.status
    assert_equal "IK_68", @interkassa.transaction_id
    assert_equal "1234", @interkassa.item_id
    assert_equal "150.15", @interkassa.gross
    assert_equal "webmoneyz", @interkassa.currency
  end

  def test_acknowledgement    
    assert @interkassa.acknowledge
  end

  def test_respond_to_acknowledge
    assert @interkassa.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    "ik_shop_id=64C18529-4B94-0B5D-7405-F2752F2B716C&ik_payment_state=success&ik_payment_amount=150.15&ik_payment_id=1234&ik_trans_id=IK_68&ik_payment_desc=test&ik_paysystem_alias=webmoneyz&ik_baggage_fields=tel:+80441234567&ik_payment_timestamp=1196087212&ik_currency_exch=1&ik_fees_payer=1&ik_sign_hash=0DAFC81ECC575DA3FEE74556E2F18682"
  end  
end
