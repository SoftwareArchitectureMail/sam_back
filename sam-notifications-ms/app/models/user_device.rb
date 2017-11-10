class UserDevice < ApplicationRecord
  validates :username, :device_id, presence: true

  def self.notifications(first_result = 0, max_result = 0)
    max_result = UserDevice.count if max_result == 0
    UserDevice.limit(max_result).offset(first_result)
  end

  def self.get_device_id(username)
    select("device_id").where(username: username)
  end
end
