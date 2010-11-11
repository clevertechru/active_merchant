require 'test_helper'

class BeelineModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_helper_method
    assert_instance_of Beeline::Helper, Beeline.helper(123, 'test')
  end

  def test_notification_method
    assert_instance_of Beeline::Notification, Beeline.notification('name=cody')
  end
end 
