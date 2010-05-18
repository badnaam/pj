require 'test_helper'

class MerchantmembershipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:merchantmemberships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create merchantmembership" do
    assert_difference('Merchantmembership.count') do
      post :create, :merchantmembership => { }
    end

    assert_redirected_to merchantmembership_path(assigns(:merchantmembership))
  end

  test "should show merchantmembership" do
    get :show, :id => merchantmemberships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => merchantmemberships(:one).to_param
    assert_response :success
  end

  test "should update merchantmembership" do
    put :update, :id => merchantmemberships(:one).to_param, :merchantmembership => { }
    assert_redirected_to merchantmembership_path(assigns(:merchantmembership))
  end

  test "should destroy merchantmembership" do
    assert_difference('Merchantmembership.count', -1) do
      delete :destroy, :id => merchantmemberships(:one).to_param
    end

    assert_redirected_to merchantmemberships_path
  end
end
