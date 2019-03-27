# frozen_string_literal: true

class RotationsController < ApplicationController

  def create
    result = ::CreateKeyRotationsJobOrganizer.call

    if result.success?
      render json: { message: t("rotations.errors.job_queued") }, status: :ok
    else
      render json: { message: result.message }, status: result.status
    end
  end

  def status
    result = Rotations::FindInProgressRotation.call

    if result.success?
      render json: { message: t("rotations.status.none_queued") }, status: :ok
    else
      render json: { message: t(result.message) }, status: result.status
    end
  end
end
