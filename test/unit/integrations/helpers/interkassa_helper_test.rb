require 'test_helper'

class InterkassaHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
    @helper = Interkassa::Helper.new(1234,'64C18529-4B94-0B5D-7405-F2752F2B716C', :amount => 500, :currency => 'webmoneyz', :secret => 'secret')
  end
 
  def test_basic_helper_fields
    assert_field 'ik_shop_id', '64C18529-4B94-0B5D-7405-F2752F2B716C'

    assert_field 'ik_payment_amount', '500'
    assert_field 'ik_payment_id', '1234'
    assert_field 'ik_paysystem_alias', 'webmoneyz'
  end
  
  def test_custom_fields
    @helper.custom_fields 'tel: +123 456 7890'
    
    assert_field 'ik_baggage_fields', 'tel: +123 456 7890'
  end
  
  def test_signature_string_generation
    @helper.custom_fields 'tel: +123 456 7890'
    
    assert_equal '64C18529-4B94-0B5D-7405-F2752F2B716C:500:1234:webmoneyz:tel: +123 456 7890:secret', @helper.generate_signature_string
  end
  
  def test_signature_generation
    @helper.custom_fields 'tel: +123 456 7890'
    
    assert_equal 'DBCDB2A60049C50AEABC33C27E02A550', @helper.form_fields['ik_sign_hash']
  end
end
