# frozen_string_literal: true

class Rotations::QueueRotationJob < BaseInteractor

  def call
    RotateKeysJob.perform_later
  end
end
