# frozen_string_literal: true

class AddUniqueIndexToEncryptedStringsEncryptedValueIv < ActiveRecord::Migration[5.2]

  def change
    add_index :encrypted_strings, :encrypted_value_iv, unique: true
  end
end
