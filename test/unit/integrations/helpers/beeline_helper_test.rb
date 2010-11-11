require 'test_helper'

class BeelineHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
    time = DateTime.civil(2010, 8, 11, 13, 8, 43)
    DateTime.stubs(:now).returns(time)
    @helper = Beeline::Helper.new(1234,'ab94xr8a', :amount => 123.45, :secret => 'secret')
  end
 
  def test_basic_helper_fields
    assert_field 'os', '123.45'
    assert_field 'ic', '1234'
  end
  
  def test_answer_field
    @helper.answer 'You payment has been proceeded!'
    
    assert_field 'an', 'You payment has been proceeded!'
  end

  def test_url_generation
    assert_equal 'http://b2b.m-commerce.ru/store/ab94xr8a', @helper.full_service_url
  end
  
  def test_signature_string_generation
    assert_equal '20100811130843:secret:1234:123.45', @helper.generate_signature_string
  end

  def test_successful_invoice_announcement
    Net::HTTP.expects(:post_form).with(
        URI.parse('http://b2b.m-commerce.ru/store/ab94xr8a'),
        {'ic' => '1234', 'os' => '123.45', 'cmd' => 'create', 'dt' => '20100811130843', 'cs' => '45c69770563c054487535cfe39333fd1'}
    ).returns('0')
    assert @helper.announce_invoice
  end

  def test_unsuccessful_invoice_announcement
    Net::HTTP.expects(:post_form).with(
        URI.parse('http://b2b.m-commerce.ru/store/ab94xr8a'),
        {'ic' => '1234', 'os' => '123.45', 'cmd' => 'create', 'dt' => '20100811130843', 'cs' => '45c69770563c054487535cfe39333fd1'}
    ).returns('2')
    assert !@helper.announce_invoice
  end
end
