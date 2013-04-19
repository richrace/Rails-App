require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase
  
  fixtures :all
  
  test "invalid without content" do
    broadcast = Broadcast.new
    assert !broadcast.valid?
    assert broadcast.errors[:content].any?
  end
  
  test "check has job" do
    broadcast = Broadcast.new
    job = Job.new(broadcast.id)
    broadcast.job = job
    assert broadcast.has_job?
  end
  
  test "check does not have job" do
    broadcast = Broadcast.new
    assert !broadcast.has_job?
  end
  
  test "check has newsblog" do
    broadcast = Broadcast.new
    newsblog = Newsblog.new(broadcast.id)
    broadcast.newsblog = newsblog
    assert broadcast.has_newsblog?
  end
  
  test "check does not have newblog" do
    broadcast = Broadcast.new
    assert !broadcast.has_newsblog?
  end
  
  test "should get Job as type" do
    broadcast = Broadcast.new
    job = Job.new(broadcast.id)
    broadcast.job = job
    broadcast.feed_type = Broadcast::JOB_S
    assert_match Broadcast::JOB_S, broadcast.feed_type
  end
  
  test "should get newsblog as type" do
    broadcast = Broadcast.new
    newsblog = Newsblog.new(broadcast.id)
    broadcast.newsblog = newsblog
    broadcast.feed_type = Broadcast::NEWSBLOG_S
    assert_match Broadcast::NEWSBLOG_S, broadcast.feed_type
  end
  
  test "should get author" do
    broadcast = broadcasts(:one)
    user = users(:admin)
    broadcast.user = user
    name = user.firstname + " " + user.surname
    assert_match name, broadcast.getAuthor
  end
  
  test "should get some text back" do
    broadcast = broadcasts(:one)
    assert !broadcast.to_s.blank?
  end
end