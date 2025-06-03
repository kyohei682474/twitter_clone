# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include NotificationMailerHelper
  default from: 'from@example.com'
  layout 'mailer'
end
