require 'test_helper'

class LiqpayHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
    @helper = Liqpay::Helper.new(1234, 'merch1', :amount => 500, :currency => 'USD')
  end
 
  def test_basic_helper_fields
    assert_field 'merchant_id', 'merch1'

    assert_field 'amount', '500'
    assert_field 'order_id', '1234'
    assert_field 'currency', 'USD'
    assert_field 'version', '1.1'
  end
  
  def test_description
    @helper.description 'This is my description'
    assert_field 'description', 'This is my description'
  end
  
  def test_notify_url
    @helper.notify_url 'http://example.com/notify'
    assert_field 'server_url', 'http://example.com/notify'
  end
  
  def test_return_url
    @helper.return_url 'http://example.com/return'
    assert_field 'result_url', 'http://example.com/return'
  end
end
