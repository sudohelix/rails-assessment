# frozen_string_literal: true

require "test_helper"

class RotateKeysJobTest < ActiveJob::TestCase

  test "job queues on the default queue" do
    assert RotateKeysJob.new.queue_name == "default"
  end

  test "generates a new primary decryption key" do
    initial_key = DataEncryptingKey.generate!(primary: true)
    RotateKeysJob.new.perform

    assert_not_equal initial_key.id, DataEncryptingKey.primary.id
  end

  test "all encrypted strings are rencrypted with the new primary key" do
    old_primary_encryption_key = DataEncryptingKey.primary
    encrypted_strings = (1..5).map { EncryptedString.create!(value: Faker::Company.bs) }

    encrypted_strings.each { |string| assert_equal old_primary_encryption_key.id, string.data_encrypting_key_id }

    RotateKeysJob.new.perform

    new_primary_encryption_key = DataEncryptingKey.primary
    EncryptedString.find_each do |string|
      assert_equal new_primary_encryption_key.id, string.data_encrypting_key_id
      assert_not_equal old_primary_encryption_key, new_primary_encryption_key
    end
  end

  test "all old, unused data encryption keys should be deleted" do
    (1..5).map { EncryptedString.create!(value: Faker::Company.bs) }
    (1..4).map { DataEncryptingKey.generate! } # non-primary keys

    old_primary_encrypting_key = DataEncryptingKey.primary

    assert_difference -> { DataEncryptingKey.count }, -4 do
      RotateKeysJob.new.perform
    end
    assert_not_equal DataEncryptingKey.primary, old_primary_encrypting_key
  end
end
