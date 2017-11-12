class CreateUserDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :user_devices do |t|
      t.string :username
      t.string :device_id

      t.timestamps
    end
  end
end
