# frozen_string_literal: true

class DataEncryptingKey < ApplicationRecord

  attr_encrypted :key,
                 key: :key_encrypting_key

  validates :key, presence: true

  def self.primary
    find_by(primary: true)
  end

  def self.generate!(attrs = {})
    create!(attrs.merge(key: AES.key))
  end

  def key_encrypting_key
    Rails.application.secrets.key_encrypting_key
  end
end
