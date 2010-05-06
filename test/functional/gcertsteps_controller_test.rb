require 'test_helper'

class GcertstepsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gcertsteps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gcertstep" do
    assert_difference('Gcertstep.count') do
      post :create, :gcertstep => { }
    end

    assert_redirected_to gcertstep_path(assigns(:gcertstep))
  end

  test "should show gcertstep" do
    get :show, :id => gcertsteps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => gcertsteps(:one).to_param
    assert_response :success
  end

  test "should update gcertstep" do
    put :update, :id => gcertsteps(:one).to_param, :gcertstep => { }
    assert_redirected_to gcertstep_path(assigns(:gcertstep))
  end

  test "should destroy gcertstep" do
    assert_difference('Gcertstep.count', -1) do
      delete :destroy, :id => gcertsteps(:one).to_param
    end

    assert_redirected_to gcertsteps_path
  end
end
