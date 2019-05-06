# frozen_string_literal: true

class CreateKeyRotationsJobOrganizer < BaseOrganizer

  organize Rotations::FindInProgressRotation,
           Rotations::QueueRotationJob
end
