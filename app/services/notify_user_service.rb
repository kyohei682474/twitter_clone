# frozen_string_literal: true

class NotifyUserService
  def self.call(actor:, recipient:, notifiable:, action_type:)
    return if actor == recipient

    notification = Notification.create(
      actor: actor,
      recipient: recipient,
      notifiable: notifiable,
      action_type: action_type
    )
    
    return unless notification.persisted?

    NotificationMailer.with(
      recipient: recipient,
      actor: actor,
      notifiable: notifiable,
      action_type: action_type
    ).notify.deliver_now
  end
end
