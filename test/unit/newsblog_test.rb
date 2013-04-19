require 'test_helper'

class NewsblogTest < ActiveSupport::TestCase
  
  test "invalid without broadcast" do
    newsblog = Newsblog.new
    assert !newsblog.valid?
    assert newsblog.errors[:broadcast_id].any?
  end
  
end
