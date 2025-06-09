# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify
    @recipient = params[:recipient]
    @actor = params[:actor]
    @notifiable = params[:notifiable]
    @action_type = params[:action_type]

    mail(
      to: @recipient.email,
      from: ENV['DEFAULT_FROM_EMAIL'],
      subject: '新しい通知が届いています'
    )
  end
end
