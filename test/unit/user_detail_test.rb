require 'test_helper'

class UserDetailTest < ActiveSupport::TestCase
  
  fixtures :all
  
  test "unique login fail" do
    admin_usr = users(:admin)
    admin_usr.user_detail = user_details(:admin)
    
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    user_det = UserDetail.new(:login => "admin",
                                      :password => "test",
                                      :user => user,
                                      :level => UserDetail::ADMIN_LEVEL)
    assert !user_det.save
  end
  
  test "unique login sccuess" do
    admin_usr = users(:admin)
    admin_usr.user_detail = user_details(:admin)
    
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    user_det = UserDetail.new(:login => "test_user",
                              :password => "test",
                              :password_confirmation => "test",
                              :user => user,
                              :level => UserDetail::ADMIN_LEVEL)
    assert user_det.save
  end
  
  test "login missing" do
    admin_usr = users(:admin)
    admin_usr.user_detail = user_details(:admin)
    
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    user_det = UserDetail.new(:password => "test",
                              :password_confirmation => "test",
                              :user => user,
                              :level => UserDetail::ADMIN_LEVEL)
    assert !user_det.save
  end
  
  test "check password confirmation success" do
    pass = "pass"
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    det_usr = UserDetail.new(:login => "test",
                             :password => pass,
                             :password_confirmation => pass,
                             :user => user,
                             :level => UserDetail::ADMIN_LEVEL)    
    assert det_usr.save
  end
  
  test "check password confirmation fail" do
    pass = "pass"
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    det_usr = UserDetail.new(:login => "test",
                             :password => pass,
                             :password_confirmation => "test",
                             :user => user,
                             :level => UserDetail::ADMIN_LEVEL)   
    assert !det_usr.save
  end
  
  test "check auth success" do
    pass = "pass"
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    det_usr = UserDetail.new(:login => "test",
                             :password => pass,
                             :password_confirmation => pass,
                             :user => user,
                             :level => UserDetail::ADMIN_LEVEL)
    det_usr.save
    
    assert_not_nil(UserDetail.authenticate("test", pass))
  end
  
  test "check auth fail - wrong username" do
    pass = "pass"
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    det_usr = UserDetail.new(:login => "test",
                             :password => pass,
                             :password_confirmation => pass,
                             :user => user,
                             :level => UserDetail::ADMIN_LEVEL)
    det_usr.save
    
    assert_nil(UserDetail.authenticate("Bob", pass))
  end
  
  test "check auth fail - wrong password" do
    pass = "pass"
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :grad_year => 1985,
                    :email => "test@test.com")
    user.save
    det_usr = UserDetail.new(:login => "test",
                             :password => pass,                            
                             :password_confirmation => pass,
                             :user => user,
                             :level => UserDetail::ADMIN_LEVEL)
    det_usr.save
    
    assert_nil(UserDetail.authenticate("test", "wrong_pass"))
  end
  
end