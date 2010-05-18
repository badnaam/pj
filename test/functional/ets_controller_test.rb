require 'test_helper'

class EtsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create et" do
    assert_difference('Et.count') do
      post :create, :et => { }
    end

    assert_redirected_to et_path(assigns(:et))
  end

  test "should show et" do
    get :show, :id => ets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ets(:one).to_param
    assert_response :success
  end

  test "should update et" do
    put :update, :id => ets(:one).to_param, :et => { }
    assert_redirected_to et_path(assigns(:et))
  end

  test "should destroy et" do
    assert_difference('Et.count', -1) do
      delete :destroy, :id => ets(:one).to_param
    end

    assert_redirected_to ets_path
  end
end
