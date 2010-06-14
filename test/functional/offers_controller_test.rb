require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create offer" do
    assert_difference('Offer.count') do
      post :create, :offer => { }
    end

    assert_redirected_to offer_path(assigns(:offer))
  end

  test "should show offer" do
    get :show, :id => offers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => offers(:one).to_param
    assert_response :success
  end

  test "should update offer" do
    put :update, :id => offers(:one).to_param, :offer => { }
    assert_redirected_to offer_path(assigns(:offer))
  end

  test "should destroy offer" do
    assert_difference('Offer.count', -1) do
      delete :destroy, :id => offers(:one).to_param
    end

    assert_redirected_to offers_path
  end
end
