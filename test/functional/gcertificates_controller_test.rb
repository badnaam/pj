require 'test_helper'

class GcertificatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gcertificates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gcertificate" do
    assert_difference('Gcertificate.count') do
      post :create, :gcertificate => { }
    end

    assert_redirected_to gcertificate_path(assigns(:gcertificate))
  end

  test "should show gcertificate" do
    get :show, :id => gcertificates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => gcertificates(:one).to_param
    assert_response :success
  end

  test "should update gcertificate" do
    put :update, :id => gcertificates(:one).to_param, :gcertificate => { }
    assert_redirected_to gcertificate_path(assigns(:gcertificate))
  end

  test "should destroy gcertificate" do
    assert_difference('Gcertificate.count', -1) do
      delete :destroy, :id => gcertificates(:one).to_param
    end

    assert_redirected_to gcertificates_path
  end
end
