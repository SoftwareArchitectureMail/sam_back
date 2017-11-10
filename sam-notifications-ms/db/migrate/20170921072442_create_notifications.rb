class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :username
      t.string :sender

      t.timestamps
    end
  end
end
