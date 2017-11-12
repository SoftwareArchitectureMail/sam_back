class Notification < ApplicationRecord
  validates :username, :sender, presence: true

  def self.notifications(first_result = 0, max_result = 0)
    max_result = Notification.count if max_result == 0
    Notification.limit(max_result).offset(first_result)
  end
end
