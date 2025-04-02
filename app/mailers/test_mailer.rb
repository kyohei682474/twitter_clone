class TestMailer < ApplicationMailer
  default from: '18kyohei@sandboxe0a8b94f9d0e4071886f4e8c46377961.mailgun.org'

  def send_email(to)
    mail(
      to: to,
      from: ENV['MAILGUN_SMTP_LOGIN'],
      subject: 'Test Mail',
      body: 'GitHub認証メール'
    )
  end
end
