class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.integer :gender
      t.date :date_birth
      t.integer :mobile_phone
      t.string :current_email
      t.integer :location

      t.timestamps
    end
  end
end
