class Notification < ApplicationRecord
  belongs_to :user
  scope :friend_requests, -> { where('notification_type = friendRequest') }
  scope :likes, -> { where('notification_type = like') }
  scope :comments, -> { where('notification_type = comment') }
end
