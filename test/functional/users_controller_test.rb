require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:admin)
  end

  test "should get index" do
    login_as(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    login_as(:admin)
    get :new
    assert_response :success
  end

  test "should create user" do
    login_as(:admin)
    @user.email = 'cwl1@aber.ac.uk'
    assert_difference('User.count') do
      post :create, :user => @user.attributes
    end
    assert_redirected_to "#{user_path(assigns(:user))}?page=1"
  end

  test "should show user" do
    login_as(:admin)
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    login_as(:admin)
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    login_as(:admin)
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to "#{user_path(assigns(:user))}?page=1"
  end

  test "should destroy user" do
    login_as(:admin)
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end
    assert_redirected_to "#{users_path}?page=1"
  end
end
