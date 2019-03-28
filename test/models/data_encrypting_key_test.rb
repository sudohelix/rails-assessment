# frozen_string_literal: true

require "test_helper"

class DataEncryptingKeyTest < ActiveSupport::TestCase

  should validate_presence_of(:key)
  should validate_exclusion_of(:primary).in_array([nil])

  test ".generate!" do
    assert_difference "DataEncryptingKey.count", 1 do
      key = DataEncryptingKey.generate!
      assert key
    end
  end

  test "#primary attribute will be false by default" do
    key = DataEncryptingKey.generate!

    assert_not key.primary?
    assert_not_equal nil, key.primary
  end

  test "#primary attribute will not be set to false by default if create as primary" do
    key = DataEncryptingKey.generate!(primary: true)
    assert key.reload.primary?
  end

  test "#primary will create a key if it does not exist" do
    assert_difference -> { DataEncryptingKey.where(primary: true).count }, 1 do
      DataEncryptingKey.primary
    end
  end
end
