# frozen_string_literal: true

require "test_helper"

class RotateKeysJobTest < ActiveJob::TestCase

  test "job queues on the default queue" do
    assert RotateKeysJob.new.queue_name == "default"
  end
end
