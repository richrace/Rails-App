require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    # Have to fix relationship mappings for Ruby as the 
    # database has the keys but not the ORM "magic"
    @job = jobs(:one)
    @broadcast = broadcasts(:one)
    @job.broadcast = @broadcast
    @broadcast.job = @job
    @user = users(:admin)
    @user.user_detail = user_details(:admin)
    @broadcast.user = @user
    @feed = feeds(:one)
    @broadcast.feeds << @feed
    @job.save
    @broadcast.save
    
    job2 = jobs(:two)
    broad = broadcasts(:two)
    broad.job = job2
    job2.broadcast = broad
    broad.user = @user
    broad.feeds << @feed
    job2.save
    broad.save
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end
  
  test "should get xml list" do
    get :index, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:jobs)
  end
  
  test "should get json" do
    get :index, :format => "json"
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should show job" do
    get :show, :id => @job.id
    assert_response :success
  end
  
  test "should show job in xml" do
    get :show, :id => @job.id, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:job)
  end
  
  test "should show job in json" do
    get :show, :id => @job.id, :format => "json"
    assert_response :success
    assert_not_nil assigns(:job)
  end

  test "should destroy job as admin" do
    login_as(:admin)
    assert_difference('Job.count', -1) do
      delete :destroy, :id => @job.to_param
    end
    assert_redirected_to "#{jobs_path}?page=1"
  end
  
  test "should get atom feed" do
     get :feed, :format => "atom"
     assert_response :success
  end

  test "should get rss feed" do
     get :feed, :format => "rss"
     assert_response :success
   end
      
  test "should destroy job as contributor" do
    login_as(:contributor)
    broad = broadcasts(:contributor)
    usr = users(:contributor)
    broad.user = usr
    usr.user_detail = user_details(:contributor)
    j = jobs(:contributor)

    assert_difference('Job.count', -1) do
      delete :destroy, :id => j.to_param
    end
    assert_redirected_to "#{jobs_path}?page=1"
  end
  
  test "should fail to destroy job as contributor when job is not contributor's" do
    login_as(:contributor)
    broad = broadcasts(:editor)
    usr = users(:editor)
    broad.user = usr
    usr.user_detail = user_details(:editor)
    j = jobs(:editor)
    
    assert_difference('Job.count', 0) do
      delete :destroy, :id => j.to_param
    end
      assert_redirected_to root_path
  end

  test "should to destroy job as editor when job is not contributor's" do
    login_as(:editor)
    broad = broadcasts(:contributor)
    usr = users(:contributor)
    broad.user = usr
    usr.user_detail = user_details(:contributor)
    j = jobs(:contributor)

    assert_difference('Job.count', -1) do
      delete :destroy, :id => j.to_param
    end
      assert_redirected_to "#{jobs_path}?page=1"
  end

   test "should fail to destroy job as register" do
     login_as(:register)

     assert_difference('Job.count', 0) do
       delete :destroy, :id => @job.to_param
     end
     assert_redirected_to root_path
   end

   test "should fail to destroy broadcast as normal user" do
     login_as(:normal)

     assert_difference('Job.count', 0) do
       delete :destroy, :id => @job.to_param
     end
     assert_redirected_to root_path
   end

   test "should fail to destroy job as anonymous" do    
     assert_difference('Job.count', 0) do
       delete :destroy, :id => @job.to_param
     end
     assert_redirected_to root_path
   end

   test "should fail to destroy job as no job present" do    
     login_as(:admin)
     assert_difference('Job.count', 0) do
       delete :destroy, :id => "123456789"
     end
     assert_redirected_to "#{jobs_path}?page=1"
   end

   test "should fail to show job as no job format html" do    
     login_as(:admin)
     get :show, :id => "123456789"
     assert_redirected_to "#{jobs_path}?page=1"
     assert_nil assigns(:jobs)
   end

   test "should fail to show job as no job format json" do    
     login_as(:admin)
     get :show, :id => "123456789", :format => :json
     assert_response :missing
   end

   test "should fail to show job as no job format xml" do
     login_as(:admin)
     get :show, :id => "123456789", :format => :xml
     assert_response :missing
   end

end
