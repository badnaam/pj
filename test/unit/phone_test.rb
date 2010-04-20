require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Phone.new.valid?
  end
end
