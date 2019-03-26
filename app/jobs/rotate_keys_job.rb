# frozen_string_literal: true

class RotateKeysJob < ApplicationJob

  JOB_QUEUE = :default

  queue_as JOB_QUEUE

  def perform(*args)
    # Do something later
  end
end
