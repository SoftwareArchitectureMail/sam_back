class ChangeIntegerLimitInUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :mobile_phone, :integer, limit: 8
  end
end
