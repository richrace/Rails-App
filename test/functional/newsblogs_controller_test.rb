require 'test_helper'

class NewsblogsControllerTest < ActionController::TestCase
  setup do
    # Have to fix relationship mappings for Ruby as the 
    # database has the keys but not the ORM "magic"
    @newsblog = newsblogs(:one)
    @broadcast = broadcasts(:three)
    @newsblog.broadcast = @broadcast
    @broadcast.newsblog = @newsblog
    @user = users(:admin)
    @broadcast.user = @user
    @user.user_detail = user_details(:admin)
    @feed = feeds(:one)
    @broadcast.feeds << @feed
    @newsblog.save
    @broadcast.save
    
    n = newsblogs(:two)
    broad = broadcasts(:four)
    broad.newsblog = n
    n.broadcast = broad
    broad.user = @user
    broad.feeds << @feed
    n.save
    broad.save
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:newsblogs)
  end
  
  test "should get xml list" do
    get :index, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:newsblogs)
  end
  
  test "should get json" do
    get :index, :format => "json"
    assert_response :success
    assert_not_nil assigns(:newsblogs)
  end

  test "should show newsblog" do
    get :show, :id => @newsblog.id
    assert_response :success
  end
  
  test "should show newsblog in xml" do
    get :show, :id => @newsblog.id, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:newsblog)
  end
  
  test "should show newsblog in json" do
    get :show, :id => @newsblog.id, :format => "json"
    assert_response :success
    assert_not_nil assigns(:newsblog)
  end

  test "should destroy newsblog as admin" do
    login_as(:admin)
    assert_difference('Newsblog.count', -1) do
      delete :destroy, :id => @newsblog.to_param
    end
    assert_redirected_to "#{newsblogs_path}?page=1"
  end
  
  test "should get atom feed" do
    get :feed, :format => "atom"
    assert_response :success
  end
 
  test "should get rss feed" do
    get :feed, :format => "rss"
    assert_response :success
  end
  
  test "should destroy newsblog as contributor" do
    login_as(:contributor)
    broad = broadcasts(:n_contrib)
    usr = users(:contributor)
    broad.user = usr
    usr.user_detail = user_details(:contributor)
    n = newsblogs(:contributor)

    assert_difference('Newsblog.count', -1) do
      delete :destroy, :id => n.to_param
    end
    assert_redirected_to "#{newsblogs_path}?page=1"
  end
  
  test "should fail to destroy newsblog as contributor when newblog is not contributor's" do
    login_as(:contributor)
    broad = broadcasts(:n_editor)
    usr = users(:editor)
    broad.user = usr
    usr.user_detail = user_details(:editor)
    n = newsblogs(:editor)
    
    assert_difference('Newsblog.count', 0) do
      delete :destroy, :id => n.to_param
    end
      assert_redirected_to root_path
  end

  test "should to destroy newsblog as editor when newsblog is not contributor's" do
    login_as(:editor)
    broad = broadcasts(:n_contrib)
    usr = users(:contributor)
    broad.user = usr
    usr.user_detail = user_details(:contributor)
    n = newsblogs(:contributor)

    assert_difference('Newsblog.count', -1) do
      delete :destroy, :id => n.to_param
    end
      assert_redirected_to "#{newsblogs_path}?page=1"
  end

  test "should fail to destroy newsblog as register" do
    login_as(:register)

    assert_difference('Newsblog.count', 0) do
      delete :destroy, :id => @newsblog.to_param
    end
    assert_redirected_to root_path
  end

  test "should fail to destroy newsblog as normal user" do
    login_as(:normal)

    assert_difference('Newsblog.count', 0) do
      delete :destroy, :id => @newsblog.to_param
    end
    assert_redirected_to root_path
  end

  test "should fail to destroy newsblog as anonymous" do    
    assert_difference('Newsblog.count', 0) do
      delete :destroy, :id => @newsblog.to_param
    end
    assert_redirected_to root_path
  end

  test "should fail to destroy newsblog as no newsblog present" do    
    login_as(:admin)
    assert_difference('Newsblog.count', 0) do
      delete :destroy, :id => "123456789"
    end
    assert_redirected_to "#{newsblogs_path}?page=1"
  end

  test "should fail to show newsblog as no newsblog format html" do    
    login_as(:admin)
    get :show, :id => "123456789"
    assert_redirected_to "#{newsblogs_path}?page=1"
    assert_nil assigns(:jobs)
  end

  test "should fail to show newsblog as no newsblog format json" do    
    login_as(:admin)
    get :show, :id => "123456789", :format => :json
    assert_response :missing
  end

  test "should fail to show newsblog as no newsblog format xml" do
    login_as(:admin)
    get :show, :id => "123456789", :format => :xml
    assert_response :missing
  end
  
end
