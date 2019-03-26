# frozen_string_literal: true

class EncryptedString < ApplicationRecord

  belongs_to :data_encrypting_key

  attr_encrypted :value,
                 mode: :per_attribute_iv_and_salt,
                 key: :primary_encryption_key

  validates :token, presence: true, uniqueness: true
  validates :data_encrypting_key, presence: true
  validates :value, presence: true

  before_validation :set_token, :set_data_encrypting_key

  def primary_encryption_key
    self.data_encrypting_key ||= DataEncryptingKey.primary
    data_encrypting_key.encrypted_key
  end

  private

  def encryption_key
    self.data_encrypting_key ||= DataEncryptingKey.primary
    data_encrypting_key.key
  end

  def set_token
    loop do
      self.token = SecureRandom.hex
      break if EncryptedString.where(token: token).blank?
    end
  end

  def set_data_encrypting_key
    self.data_encrypting_key ||= DataEncryptingKey.primary
  end
end
