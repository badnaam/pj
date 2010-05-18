require 'test_helper'

class GcertificationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gcertifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gcertification" do
    assert_difference('Gcertification.count') do
      post :create, :gcertification => { }
    end

    assert_redirected_to gcertification_path(assigns(:gcertification))
  end

  test "should show gcertification" do
    get :show, :id => gcertifications(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => gcertifications(:one).to_param
    assert_response :success
  end

  test "should update gcertification" do
    put :update, :id => gcertifications(:one).to_param, :gcertification => { }
    assert_redirected_to gcertification_path(assigns(:gcertification))
  end

  test "should destroy gcertification" do
    assert_difference('Gcertification.count', -1) do
      delete :destroy, :id => gcertifications(:one).to_param
    end

    assert_redirected_to gcertifications_path
  end
end
