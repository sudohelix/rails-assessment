# frozen_string_literal: true

class RotateKeysJob < ApplicationJob

  JOB_QUEUE = :default

  queue_as JOB_QUEUE

  def perform(*_args)
    DataEncryptingKey.transaction do
      DataEncryptingKey.primary.update(primary: false)
      new_key = DataEncryptingKey.generate!(primary: true)

      EncryptedString.includes(:data_encrypting_key).find_each do |string|
        # default batch size of 1000
        string.rekey!(new_key)
      end
      DataEncryptingKey.where.not(id: new_key.id).destroy_all
    end
  end
end
