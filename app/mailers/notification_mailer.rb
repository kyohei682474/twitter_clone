class NotificationMailer < ApplicationMailer
  def notify
    @recipient = params[:recipient]
    @actor = params[:actor]
    @notifiable = params[:notifiable]
    @action_type = params[:action_type]

    mail(to: @user.email, subject: '新しい通知が届いています')
  end
end
