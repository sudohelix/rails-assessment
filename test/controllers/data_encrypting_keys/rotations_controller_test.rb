# frozen_string_literal: true

require "test_helper"

class DataEncryptingKeys::RotationsControllerTest < ActionDispatch::IntegrationTest

  test "should post create" do
    post data_encrypting_keys_rotations_url
    assert_response :success
  end

  test "should get status" do
    get status_data_encrypting_keys_rotations_url
    assert_response :success
  end
end
