require 'test_helper'

class LiqpayNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @liqpay = Liqpay::Notification.new(http_raw_data, :secret => 'secret')
  end

  def test_accessors
    assert @liqpay.complete?
    assert_equal "success", @liqpay.status
    assert_equal "513", @liqpay.transaction_id
    assert_equal "1234", @liqpay.item_id
    assert_equal "500.00", @liqpay.gross
    assert_equal "UAH", @liqpay.currency
    assert_equal "2", @liqpay.account
    assert_equal "71234567890", @liqpay.sender_phone
    assert_equal "1", @liqpay.code
  end

  def test_acknowledgement    
    assert @liqpay.acknowledge
  end

  def test_respond_to_acknowledge
    assert @liqpay.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    "version=1.1&merchant_id=2&order_id=1234&amount=500.00&currency=UAH&action_name=server_url&sender_phone=71234567890&transaction_id=513&status=success&code=1&signature=4R9CZ%2BGdRGx0%2BXmLJUkFvKZSkqc%3D"
  end  
end
