# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = %i[post get]
  OmniAuth.config.silence_get_warning = true
end
