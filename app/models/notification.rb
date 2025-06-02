class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  enum action_type: { like: 'like', comment: 'comment', retweet: 'retweet' }

  validates :action_type, presence: true
end
