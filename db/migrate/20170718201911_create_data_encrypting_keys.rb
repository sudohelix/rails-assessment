# frozen_string_literal: true

class CreateDataEncryptingKeys < ActiveRecord::Migration[5.2]

  def change
    create_table :data_encrypting_keys do |t|
      t.string :encrypted_key
      t.boolean :primary

      t.timestamps null: false
    end
  end
end
