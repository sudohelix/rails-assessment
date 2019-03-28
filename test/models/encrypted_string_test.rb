# frozen_string_literal: true

require "test_helper"

class EncryptedStringTest < ActiveSupport::TestCase

  should belong_to(:data_encrypting_key)
  should validate_presence_of(:value)

  test "should set a token when saving" do
    encrypted_string = EncryptedString.create!(value: "example string")
    assert encrypted_string.token.present?
  end

  test "should set a data_encrypting_key" do
    encrypted_string = EncryptedString.create!(value: "example string")
    assert encrypted_string.data_encrypting_key.present?
  end

  test "should use a unique value for token" do
    collision_token = SecureRandom.uuid
    good_token = SecureRandom.uuid
    SecureRandom.expects(:uuid).returns(good_token)
    SecureRandom.expects(:uuid).returns(collision_token).twice

    EncryptedString.create!(value: "example string")

    string_with_unique_token = EncryptedString.create!(value: "example string")
    assert_equal good_token, string_with_unique_token.token
  end

  test "should set the encryption key to the .primary key" do
    primary_encryption_key = DataEncryptingKey.primary
    encrypted_string = EncryptedString.new(value: "example string")

    assert_equal primary_encryption_key.id, encrypted_string.data_encrypting_key_id
  end

  test "#rekey! updates new encrypted value" do
    new_key = DataEncryptingKey.generate!
    encrypted_string = EncryptedString.create(value: "example string")

    assert_changes -> { encrypted_string.encrypted_value } do
      encrypted_string.rekey!(new_key)
    end
  end

  test "#rekey! changes the key from the previous key to the new key" do
    first_key = DataEncryptingKey.primary
    new_key = DataEncryptingKey.generate!
    encrypted_string = EncryptedString.create(value: "example string")

    assert_changes -> { encrypted_string.primary_encryption_key }, from: first_key.encrypted_key, to: new_key.encrypted_key do
      encrypted_string.rekey!(new_key)
    end
  end

  test "#rekey! changes the data_encryption_key_id to the new key id" do
    first_key = DataEncryptingKey.primary
    new_key = DataEncryptingKey.generate!
    encrypted_string = EncryptedString.create(value: "example string")

    assert_changes -> { encrypted_string.data_encrypting_key_id }, from: first_key.id, to: new_key.id do
      encrypted_string.rekey!(new_key)
    end
  end

  test "#rekey! changes nothing if the iv is blank" do
    DataEncryptingKey.primary
    new_key = DataEncryptingKey.generate!
    encrypted_string = EncryptedString.create(value: "example string")

    assert_no_changes -> { encrypted_string.encrypted_value } do
      encrypted_string.encrypted_value_iv = nil
      encrypted_string.rekey!(new_key)
    end
  end

  test "#rekey! changes nothing if encrypted value is blank" do
    DataEncryptingKey.primary
    new_key = DataEncryptingKey.generate!
    encrypted_string = EncryptedString.create(value: "example string")
    encrypted_string.encrypted_value = nil

    assert_no_changes -> { encrypted_string.encrypted_value } do
      encrypted_string.rekey!(new_key)
    end
  end
end
