require 'test_helper'

class ApisControllerTest < ActionController::TestCase
  test "should get prc" do
    get :prc
    assert_response :success
  end

  test "should get sst" do
    get :sst
    assert_response :success
  end

  test "should get ssw" do
    get :ssw
    assert_response :success
  end

  test "should get smc" do
    get :smc
    assert_response :success
  end

  test "should get snd" do
    get :snd
    assert_response :success
  end

end
