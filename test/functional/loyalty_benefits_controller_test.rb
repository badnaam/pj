require 'test_helper'

class LoyaltyBenefitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:loyalty_benefits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create loyalty_benefit" do
    assert_difference('LoyaltyBenefit.count') do
      post :create, :loyalty_benefit => { }
    end

    assert_redirected_to loyalty_benefit_path(assigns(:loyalty_benefit))
  end

  test "should show loyalty_benefit" do
    get :show, :id => loyalty_benefits(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => loyalty_benefits(:one).to_param
    assert_response :success
  end

  test "should update loyalty_benefit" do
    put :update, :id => loyalty_benefits(:one).to_param, :loyalty_benefit => { }
    assert_redirected_to loyalty_benefit_path(assigns(:loyalty_benefit))
  end

  test "should destroy loyalty_benefit" do
    assert_difference('LoyaltyBenefit.count', -1) do
      delete :destroy, :id => loyalty_benefits(:one).to_param
    end

    assert_redirected_to loyalty_benefits_path
  end
end
