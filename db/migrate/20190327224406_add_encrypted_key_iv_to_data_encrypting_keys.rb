# frozen_string_literal: true

class AddEncryptedKeyIvToDataEncryptingKeys < ActiveRecord::Migration[5.2]

  def change
    add_column :data_encrypting_keys, :encrypted_key_iv, :string, null: false, default: false
    add_index :data_encrypting_keys, :encrypted_key_iv, unique: true
  end
end
