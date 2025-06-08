# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify
    @recipient = params[:recipient]
    @actor = params[:actor]
    @notifiable = params[:notifiable]
    @action_type = params[:action_type]

    mail(
      to: @recipient.email,
      from: '18kyohei@9014563.brevosend.com', 
      subject: '新しい通知が届いています'
    )
  end
end
