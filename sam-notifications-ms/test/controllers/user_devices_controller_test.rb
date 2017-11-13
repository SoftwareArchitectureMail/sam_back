require 'test_helper'

class UserDevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_device = user_devices(:one)
  end

  test "should get index" do
    get user_devices_url, as: :json
    assert_response :success
  end

  test "should create user_device" do
    assert_difference('UserDevice.count') do
      post user_devices_url, params: { user_device: { device_id: @user_device.device_id, username: @user_device.username } }, as: :json
    end

    assert_response 201
  end

  test "should show user_device" do
    get user_device_url(@user_device), as: :json
    assert_response :success
  end

  test "should update user_device" do
    patch user_device_url(@user_device), params: { user_device: { device_id: @user_device.device_id, username: @user_device.username } }, as: :json
    assert_response 200
  end

  test "should destroy user_device" do
    assert_difference('UserDevice.count', -1) do
      delete user_device_url(@user_device), as: :json
    end

    assert_response 204
  end
end
