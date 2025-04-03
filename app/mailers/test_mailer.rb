class TestMailer < ApplicationMailer
  def send_email(to)
    mail(
      to: to,
      from: 'MS_VJC9Yl@test-nrw7gym906rg2k8e.mlsender.net',
      subject: 'Test Mail from Mailersend'
    )
  end
end
