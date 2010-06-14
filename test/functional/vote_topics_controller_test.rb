require 'test_helper'

class VoteTopicsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vote_topics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vote_topic" do
    assert_difference('VoteTopic.count') do
      post :create, :vote_topic => { }
    end

    assert_redirected_to vote_topic_path(assigns(:vote_topic))
  end

  test "should show vote_topic" do
    get :show, :id => vote_topics(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => vote_topics(:one).to_param
    assert_response :success
  end

  test "should update vote_topic" do
    put :update, :id => vote_topics(:one).to_param, :vote_topic => { }
    assert_redirected_to vote_topic_path(assigns(:vote_topic))
  end

  test "should destroy vote_topic" do
    assert_difference('VoteTopic.count', -1) do
      delete :destroy, :id => vote_topics(:one).to_param
    end

    assert_redirected_to vote_topics_path
  end
end
