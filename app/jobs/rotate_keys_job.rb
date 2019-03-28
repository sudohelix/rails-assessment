# frozen_string_literal: true

class RotateKeysJob < ApplicationJob

  JOB_QUEUE = :default

  queue_as JOB_QUEUE

  def perform(*_args)
    DataEncryptingKey.transaction do
      DataEncryptingKey.where(primary: true).find_each do |key|
        key.update(primary: false)
      end
      new_key = DataEncryptingKey.generate!(primary: true)
      EncryptedString.includes(:data_encrypting_key).find_each do |string|
        string.rekey!(new_key)
      end
    end
    DataEncryptingKey.where(primary: false).destroy_all
  end
end
