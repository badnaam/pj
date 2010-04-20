require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "password_reset" do
    @expected.subject = 'Notifier#password_reset'
    @expected.body    = read_fixture('password_reset')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifier.create_password_reset(@expected.date).encoded
  end

end
