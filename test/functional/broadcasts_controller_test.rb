require 'test_helper'

class BroadcastsControllerTest < ActionController::TestCase
  setup do
    # Login required for every action.
    @broadcast = broadcasts(:one)
    user = users(:admin)
    @broadcast.user = user
    user.user_detail = user_details(:admin)
    #login_as(:admin)
  end
  
  test "should get index as admin" do
    login_as(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should get index as contributor" do
    login_as(:contributor)
    
    get :index
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should get index as editor" do
    login_as(:editor)
    
    get :index
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "Should fail get index as register and redirect to home" do
    login_as(:register)
    
    get :index
    assert_redirected_to root_path
  end
  
  test "Should fail get index as normal user and redirect to home" do
    login_as(:normal)
    
    get :index
    assert_redirected_to root_path
  end
  
  test "Should fail get index as anonymous and redirect to login" do    
    get :index
    assert_redirected_to new_session_path 
  end
  
  test "should get xml list as admin" do
    login_as(:admin)
    
    get :index, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should get xml list as contributor" do
    login_as(:contributor)
    
    get :index, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should get xml list as editor" do
    login_as(:editor)
    
    get :index, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should fail get xml list as register" do
    login_as(:register)
    
    get :index, :format => "xml"
    assert_response :forbidden
  end
  
  test "should fail get xml list as normal user" do
    login_as(:normal)
    
    get :index, :format => "xml"
    assert_response :forbidden
  end
  
  test "should fail get xml list as anonymous" do    
    get :index, :format => "xml"
    assert_response :unauthorized
  end
  
  test "should get json list as admin" do
    login_as(:admin)
    
    get :index, :format => "json"
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should get json list as contributor" do
    login_as(:contributor)
    
    get :index, :format => "json"
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should get json list as editor" do
    login_as(:editor)
    
    get :index, :format => "json"
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end
  
  test "should fail get json list as register" do
    login_as(:register)
    
    get :index, :format => "json"
    assert_response :forbidden
  end
  
  test "should fail get json list as normal user" do
    login_as(:normal)
    
    get :index, :format => "json"
    assert_response :forbidden
  end
  
  test "should fail get json list as anonymous" do    
    get :index, :format => "json"
    assert_response :unauthorized
  end
  
  test "should show broadcast as admin" do
    login_as(:admin)
    
    get :show, :id => @broadcast.id
    assert_response :success
    assert_not_nil assigns(:broadcast)
  end
  
  test "should show broadcast as contributor if broacast is written by user" do
    login_as(:contributor)
    @broadcast = broadcasts(:contributor)
    user = users(:contributor)
    @broadcast.user = user
    user.user_detail = user_details(:contributor)
    
    get :show, :id => @broadcast.id
    assert_response :success
    assert_not_nil assigns(:broadcast)
  end
  
  test "should fail show broadcast as contributor if broacast is not written by user" do
    login_as(:contributor)
    @broadcast = broadcasts(:editor)
    user = users(:editor)
    @broadcast.user = user
    user.user_detail = user_details(:editor)
    
    get :show, :id => @broadcast.id
    assert_redirected_to root_path
  end
  
  test "should show broadcast as editor" do
    login_as(:editor)
    
    get :show, :id => @broadcast.id
    assert_response :success
    assert_not_nil assigns(:broadcast)
  end
  
  test "Should fail show broadcast as register and redirect to home" do
    login_as(:register)
    
    get :show, :id => @broadcast.id
    assert_redirected_to root_path
  end
  
  test "Should fail show broadcast as normal user and redirect to home" do
    login_as(:normal)
    
    get :show, :id => @broadcast.id
    assert_redirected_to root_path
  end
  
  test "Should fail show broadcast as anonymous" do    
    get :show, :id => @broadcast.id
    assert_redirected_to new_session_path
  end
  
  test "should show broadcast in xml as admin" do
    login_as(:admin)
    
    get :show, :id => @broadcast.id, :format => "xml"
    assert_response :success
    assert_not_nil assigns(:broadcast)
  end
  
  test "should show xml as contributor" do
    login_as(:contributor)
    @broadcast = broadcasts(:contributor)
    user = users(:contributor)
    @broadcast.user = user
    user.user_detail = user_details(:contributor)
    
    get :show, :id => @broadcast.id, :format => "xml"
    assert_response :success
  end
  
  test "should fail to show xml as contributor with broadcast not written by user" do
    login_as(:contributor)
    @broadcast = broadcasts(:editor)
    user = users(:editor)
    @broadcast.user = user
    user.user_detail = user_details(:editor)
    
    get :show, :id => @broadcast.id, :format => "xml"
    assert_response :forbidden
    assert_nil assigns(:broadcasts)
  end
  
  test "should show xml as editor" do
    login_as(:editor)
    
    get :show, :id => @broadcast.id, :format => "xml"
    assert_response :success
  end
  
  test "should fail show xml as register" do
    login_as(:register)
    
    get :show, :id => @broadcast.id, :format => "xml"
    assert_response :forbidden
    assert_nil assigns(:broadcasts)
  end
  
  test "should fail show xml as normal user" do
    login_as(:normal)
    
    get :show, :id => @broadcast.id, :format => "xml"
    assert_response :forbidden
    assert_nil assigns(:broadcasts)
  end
  
  test "should fail show xml as anonymous" do
    get :show, :id => @broadcast.id, :format => "xml"
    assert_response :unauthorized
    assert_nil assigns(:broadcasts)
  end
  
  test "should show broadcast in json" do
    login_as(:admin)
    
    get :show, :id => @broadcast.id, :format => "json"
    assert_response :success
    assert_not_nil assigns(:broadcast)
  end
  
  test "should show json as contributor" do
    login_as(:contributor)
    @broadcast = broadcasts(:contributor)
    user = users(:contributor)
    @broadcast.user = user
    user.user_detail = user_details(:contributor)
    
    get :show, :id => @broadcast.id, :format => "json"
    assert_response :success
  end
  
  test "should fail to show json as contributor with broadcast not written by user" do
    login_as(:contributor)
    @broadcast = broadcasts(:editor)
    user = users(:editor)
    @broadcast.user = user
    user.user_detail = user_details(:editor)
    
    get :show, :id => @broadcast.id, :format => "json"
    assert_response :forbidden
    assert_nil assigns(:broadcasts)
  end
  
  test "should show json as editor" do
    login_as(:editor)
    
    get :show, :id => @broadcast.id, :format => "json"
    assert_response :success
  end
  
  test "should fail show json as register" do
    login_as(:register)
    
    get :show, :id => @broadcast.id, :format => "json"
    assert_response :forbidden
    assert_nil assigns(:broadcasts)
  end
  
  test "should fail show json as normal user" do
    login_as(:normal)
    
    get :show, :id => @broadcast.id, :format => "json"
    assert_response :forbidden
    assert_nil assigns(:broadcasts)
  end
  
  test "should fail show json as anonymous" do
    get :show, :id => @broadcast.id, :format => "json"
    assert_response :unauthorized
    assert_nil assigns(:broadcasts)
  end
  
  test "should get new as admin" do
    login_as(:admin)
    
    get :new
    assert_response :success
  end
  
  test "should get new as contributor" do
    login_as(:contributor)
    
    get :new
    assert_response :success
  end
  
  test "should get new as editor" do
    login_as(:contributor)
    
    get :new
    assert_response :success
  end

  test "should fail get new as register" do
    login_as(:register)
    
    get :new
    assert_redirected_to root_path
  end
  
  test "should fail get new as normal user" do
    login_as(:normal)
    
    get :new
    assert_redirected_to root_path
  end
  
  test "should fail get new as anonymous" do    
    get :new
    assert_redirected_to new_session_path
  end
  
  test "should create broadcast as admin" do
    login_as(:admin)
    
    @broadcast.content = "Create Broadcast"
    assert_difference('Broadcast.count') do
      post :create, :broadcast => @broadcast.attributes, :feeds => ["blog", "rss"], :type => Broadcast::NEWSBLOG_S
    end
    assert_redirected_to "#{broadcasts_path}?page=1"
  end
  
  test "should create broadcast as contributor" do
    login_as(:contributor)
    
    @broadcast.content = "Create Broadcast"
    assert_difference('Broadcast.count') do
      post :create, :broadcast => @broadcast.attributes, :feeds => ["blog", "rss"], :type => Broadcast::NEWSBLOG_S
    end
    assert_redirected_to "#{broadcasts_path}?page=1"
  end
  
  test "should create broadcast as editor" do
    login_as(:editor)
    
    @broadcast.content = "Create Broadcast"
    assert_difference('Broadcast.count') do
      post :create, :broadcast => @broadcast.attributes, :feeds => ["blog", "rss"], :type => Broadcast::NEWSBLOG_S
    end
    assert_redirected_to "#{broadcasts_path}?page=1"
  end
  
  test "should fail create broadcast as register" do
    login_as(:register)
    
    @broadcast.content = "Create Broadcast"
    assert_difference('Broadcast.count', 0) do
      post :create, :broadcast => @broadcast.attributes, :feeds => ["blog", "rss"], :type => Broadcast::NEWSBLOG_S
    end
    assert_redirected_to root_path
  end
  
  test "should fail create broadcast as normal user" do
    login_as(:normal)
    
    @broadcast.content = "Create Broadcast"
    assert_difference('Broadcast.count', 0) do
      post :create, :broadcast => @broadcast.attributes, :feeds => ["blog", "rss"], :type => Broadcast::NEWSBLOG_S
    end
    assert_redirected_to root_path
  end
  
  test "should fail create broadcast as anonymous" do    
    @broadcast.content = "Create Broadcast"
    assert_difference('Broadcast.count', 0) do
     post :create, :broadcast => @broadcast.attributes, :feeds => ["blog", "rss"], :type => Broadcast::NEWSBLOG_S
    end
    assert_redirected_to new_session_path
  end
  
  test "should destroy broadcast as admin" do
    login_as(:admin)
    
    assert_difference('Broadcast.count', -1) do
      delete :destroy, :id => @broadcast.to_param
    end
    assert_redirected_to "#{broadcasts_path}?page=1"
  end
  
  test "should destroy broadcast as contributor on their broadcast" do
    login_as(:contributor)
    @broadcast = broadcasts(:contributor)
    user = users(:contributor)
    @broadcast.user = user
    user.user_detail = user_details(:contributor)
    
    assert_difference('Broadcast.count', -1) do
      delete :destroy, :id => @broadcast.to_param
    end
    assert_redirected_to "#{broadcasts_path}?page=1"
  end
  
  test "should fail to destroy broadcast as contributor on another broadcast" do
    login_as(:contributor)
    @broadcast = broadcasts(:editor)
    user = users(:editor)
    @broadcast.user = user
    user.user_detail = user_details(:editor)
    
    assert_difference('Broadcast.count', 0) do
      delete :destroy, :id => @broadcast.to_param
    end
    assert_redirected_to root_path
  end
  
  test "should fail to destroy broadcast as register" do
    login_as(:register)
    
    assert_difference('Broadcast.count', 0) do
      delete :destroy, :id => @broadcast.to_param
    end
    assert_redirected_to root_path
  end
  
  test "should fail to destroy broadcast as normal user" do
    login_as(:normal)
    
    assert_difference('Broadcast.count', 0) do
      delete :destroy, :id => @broadcast.to_param
    end
    assert_redirected_to root_path
  end
  
  test "should fail to destroy broadcast as anonymous" do    
    assert_difference('Broadcast.count', 0) do
      delete :destroy, :id => @broadcast.to_param
    end
    assert_redirected_to new_session_path
  end
  
  test "should fail to destroy broadcast as no broadcast" do    
    login_as(:admin)
    assert_difference('Broadcast.count', 0) do
      delete :destroy, :id => "123456789"
    end
    assert_redirected_to "#{broadcasts_path}?page=1"
  end
  
  test "should fail to show broadcast as no broadcast format html" do    
    login_as(:admin)
    get :show, :id => "123456789"
    assert_redirected_to "#{broadcasts_path}?page=1"
    assert_nil assigns(:broadcasts)
  end
  
  test "should fail to show broadcast as no broadcast format json" do    
    login_as(:admin)
    get :show, :id => "123456789", :format => :json
    assert_response :missing
  end
  
  test "should fail to show broadcast as no broadcast format xml" do    
    login_as(:admin)
    get :show, :id => "123456789", :format => :xml
    assert_response :missing
  end
  
end