require 'test_helper'

class JobTest < ActiveSupport::TestCase

  test "invalid without broadcast" do
    job = Job.new
    assert !job.valid?
    assert job.errors[:broadcast_id].any?
  end

end
