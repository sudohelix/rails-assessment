# frozen_string_literal: true

class DataEncryptingKey < ApplicationRecord

  attr_encrypted :key,
                 key: :key_encrypting_key

  validates :key, presence: true
  validates :primary, exclusion: [nil]

  def self.primary
    where(primary: true).first_or_create! do |key|
      key.assign_attributes(key: AES.key)
    end
  end

  def self.generate!(attrs = {})
    create!(attrs.merge(key: AES.key))
  end

  def key_encrypting_key
    Rails.application.secrets.key_encrypting_key
  end
end
