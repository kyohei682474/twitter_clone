# frozen_string_literal: true

class TestMailer < ApplicationMailer
  def send_email(to)
    mail(
      to: to,
      from: ENV['DEFAULT_FROM_EMAIL'],
      subject: 'Test Mail from Mailersend'
    )
  end
end
