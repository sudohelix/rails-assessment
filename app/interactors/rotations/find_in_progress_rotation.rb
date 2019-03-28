# frozen_string_literal: true

class Rotations::FindInProgressRotation < BaseInteractor

  def call
    return unless [running_jobs?, job_queued?].any?

    context.fail!(message: I18n.t!(error_message_key), status: :unprocessable_entity)
  end

  private

  def job_queued?
    @job_queued ||= begin
      return false unless [job_queue, retry_queue].map(&:size).sum.positive?

      [job_queue, retry_queue].any? { |queue| queue.any? { |job| job.klass == job_type } }
    end
  end

  def running_jobs?
    @running_jobs ||= Sidekiq::Workers.new.any? do |_, _, work|
      Rails.logger.info "HEREE"
      work["queue"] == queue_name && work["payload"]["class"] == job_type
    end
  end

  def job_queue
    @job_queue ||= Sidekiq::Queue.new(queue_name)
  end

  def retry_queue
    @retry_queue ||= Sidekiq::RetrySet.new
  end

  def job_type
    RotateKeysJob.to_s
  end

  def queue_name
    RotateKeysJob::JOB_QUEUE
  end

  def build_i18n_error_key(with:)
    "rotations.errors.#{with}"
  end

  def error_message_key
    message_key = if job_queued?
                    "job_queued"
                  elsif running_jobs?
                    "running_jobs"
                  end

    build_i18n_error_key(with: message_key)
  end
end
