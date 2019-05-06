# frozen_string_literal: true

require "application_system_test_case"

class RotationsTest < ApplicationSystemTestCase

  def setup
    RotateKeysJob.queue_adapter = :sidekiq
  end

  test "visit the index" do
    visit root_url
    assert_selector "h1", text: "String Encryptor"
  end

  test "queue job and poll until complete" do
    1000.times { EncryptedString.create!(value: "example string") }
    visit root_url

    click_on "rotate-keys-button"
    assert_text I18n.t("rotations.errors.job_queued")

    sleep(3)
    assert_text I18n.t("rotations.status.none_queued")
  end
end
