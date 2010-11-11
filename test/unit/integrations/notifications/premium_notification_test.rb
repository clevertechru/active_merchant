require 'test_helper'

class PremiumNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_accessors
    @notification = Premium.notification(http_raw_data, config)
    assert @notification.complete?
    assert_equal "success", @notification.status
    assert_equal "123456789", @notification.transaction_id
    assert_equal "7648", @notification.item_id
    assert_equal "123.45", @notification.gross
    assert_equal 123.45, @notification.amount
    assert_equal "20100811130843", @notification.received_at
  end

  def test_another_prefix
    @notification = Premium.notification(http_raw_data('5678 7648'), config)
    assert_equal "7648", @notification.item_id
  end

  def test_prefix_without_space
    @notification = Premium.notification(http_raw_data('12347648'), config)
    assert_equal "7648", @notification.item_id
  end

  def test_unknown_prefix
    @notification = Premium.notification(http_raw_data('98765 7648'), config)
    assert_equal nil, @notification.item_id
  end

  def test_acknowledgement
    @notification = Premium.notification(http_raw_data, config)
    assert @notification.acknowledge
  end

  def test_respond_to_acknowledge
    @notification = Premium.notification(http_raw_data, config)
    assert @notification.respond_to?(:acknowledge)
  end

  def test_signature_string
    @notification = Premium.notification(http_raw_data, config)
    assert_equal '12345678920100811130843secret', @notification.generate_signature_string
  end

  private
  def config
    {:secret => 'secret', :operators => {'mts' => {'prefix' => '1234'}, 'beeline' => {'prefix' => '5678'}}}
  end

  def http_raw_data(msg = '1234 7648')
    "id=123456789&user_id=79031234567&msg=#{msg}&num=7712&datetime=20100811130843&skey=abd915e84e3dd3c302a2552316993ec0&cost=123.45"
  end  
end
