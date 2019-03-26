# frozen_string_literal: true

class RotationsController < ApplicationController

  def create
    result = ::CreateKeyRotationsJobOrganizer.call

    if result.success?
      render json: ["OK"], status: :ok
    else
      render json: { message: result.message }, status: result.status
    end
  end

  def status; end
end
