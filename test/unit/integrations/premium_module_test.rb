require 'test_helper'

class PremiumModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_helper_method
    assert_instance_of Premium::Helper, Premium.helper(123, 'test')
  end

  def test_notification_method
    assert_instance_of Premium::Notification, Premium.notification('name=cody')
  end
end 
