require 'test_helper'

class InterkassaModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_helper_method
    assert_instance_of Interkassa::Helper, Interkassa.helper(123, 'test')
  end

  def test_notification_method
    assert_instance_of Interkassa::Notification, Interkassa.notification('name=cody')
  end

  def test_return_method
    assert_instance_of Interkassa::Return, Interkassa.return('name=cody')
  end
end 
