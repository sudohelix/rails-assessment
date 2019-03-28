# frozen_string_literal: true

require "test_helper"

class RotationsControllerTest < ActionDispatch::IntegrationTest

  test "#create should post" do
    post rotations_url
    assert_response :success
  end

  test "#create should have OK in response body" do
    post rotations_url
    body = JSON.parse(response.body)

    assert_includes body.keys, "message"
    assert_includes body.values, "Key rotation has been queued"
  end

  test "#status should get" do
    get status_rotations_url

    assert_response :success
  end

  test "#create should schedule a key rotation if there are no currently running jobs" do
    Sidekiq::Queue.expects(:new).returns(mock(size: 0))
    post rotations_url

    assert_response :success
  end

  test "#create should schedule a key rotation job" do
    RotateKeysJob.expects(:perform_later)

    post rotations_url
    assert_response :success
  end

  test "#create should return status: unprocessable_entity if a rotation job already queued with message" do
    Sidekiq::Queue.expects(:new).returns(mock(size: 1, any?: true))

    post rotations_url
    body = JSON.parse(response.body)

    assert_response :unprocessable_entity
    assert_includes body["message"], "Key rotation has been queued"
  end

  test "#create should return :unprocessable_entity if a key rotation is in progress with message" do
    mock_workers = [[mock, mock, { "queue" => :default, "payload" => { "class" => "RotateKeysJob" }}]]
    Sidekiq::Workers.expects(:new).returns(mock_workers)

    post rotations_url
    body = JSON.parse(response.body)

    assert_response :unprocessable_entity
    assert_includes body["message"], "Key rotation is in progress"
  end

  test "#status should return ok if there are no queued jobs" do
    get status_rotations_url
    body = JSON.parse(response.body)

    assert_response :success
    assert_includes body["message"], "No key rotation queued or in progress"
  end

  test "#status should return unprocessable entity with a message if there is a job queued" do
    Sidekiq::Queue.expects(:new).returns(mock(size: 1, any?: true))

    get status_rotations_url
    body = JSON.parse(response.body)

    assert_response :unprocessable_entity
    assert_includes body["message"], "Key rotation has been queued"
  end

  test "#status should return unprocessable entity with a message if there is a job in progress" do
    mock_workers = [[mock, mock, { "queue" => :default, "payload" => { "class" => "RotateKeysJob" }}]]
    Sidekiq::Workers.expects(:new).returns(mock_workers)

    get status_rotations_url
    body = JSON.parse(response.body)

    assert_response :unprocessable_entity
    assert_includes body["message"], "Key rotation is in progress"
  end
end
