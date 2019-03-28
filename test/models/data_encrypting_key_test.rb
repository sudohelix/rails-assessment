# frozen_string_literal: true

require "test_helper"

class DataEncryptingKeyTest < ActiveSupport::TestCase

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
end
