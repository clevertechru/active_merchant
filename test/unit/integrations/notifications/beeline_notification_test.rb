require 'test_helper'

class BeelineNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @notification = Beeline.notification(http_raw_data, :secret => 'secret')
  end

  def test_accessors
    assert @notification.complete?
    assert_equal "success", @notification.status
    assert_equal "123456789", @notification.transaction_id
    assert_equal "1234", @notification.item_id
    assert_equal "150.15", @notification.gross
    assert_equal "20100811130843", @notification.received_at
  end

  def test_acknowledgement
    assert @notification.acknowledge
  end

  def test_respond_to_acknowledge
    assert @notification.respond_to?(:acknowledge)
  end

  def test_signature_string
    assert_equal '123456789secret790312345671234150.1520100811130843', @notification.generate_signature_string
  end

  private
  def http_raw_data
    "id=123456789&phone=79031234567&order=1234&sum=150.15&datetime=20100811130843&control=658d5b5d52087b3879ec3e0555355e87"
  end  
end
