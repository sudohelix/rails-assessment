class ChangePrimaryToDissalowNullOnDataEncryptingKeys < ActiveRecord::Migration[5.2]
  def change
    change_column :data_encrypting_keys, :primary, :boolean, null: false, default: false
  end
end
