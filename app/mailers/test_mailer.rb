class TestMailer < ApplicationMailer
<<<<<<< HEAD
  def send_email(to)
    mail(
      to: to,
      from: 'MS_VJC9Yl@test-nrw7gym906rg2k8e.mlsender.net',
      subject: 'Test Mail from Mailersend'
=======
  default from: '18kyohei@sandboxe0a8b94f9d0e4071886f4e8c46377961.mailgun.org'

  def send_email(to)
    mail(
      to: to,
      from: ENV['MAILGUN_SMTP_LOGIN'],
      subject: 'Test Mail',
      body: 'GitHub認証メール'
>>>>>>> 0dd7096 (本番環境用のメールの設定を行った)
    )
  end
end
