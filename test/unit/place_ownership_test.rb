require 'test_helper'

class MerchantOwnershipTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert MerchantOwnership.new.valid?
  end
end
