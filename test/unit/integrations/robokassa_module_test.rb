require 'test_helper'

class RobokassaModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_helper_method
    assert_instance_of Robokassa::Helper, Robokassa.helper(123, 'test')
  end
  
  def test_notification_method
    assert_instance_of Robokassa::Notification, Robokassa.notification('name=cody')
  end
  
  def test_return_method
    assert_instance_of Robokassa::Return, Robokassa.return('name=cody')
  end
end 
