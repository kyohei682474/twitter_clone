# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    OmniAuth.config.test_mode = true
  end

  config.after do
    OmniAuth.config.mock_auth[:github] = nil
  end
end
