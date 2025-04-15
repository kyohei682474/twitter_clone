# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :configure_account_update_params, only: [:update]
    before_action :configure_sign_up_params, only: [:create]
    # rubocop:enable Rails/LexicallyScopedActionFilter

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone_number birthdate])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[phone_number birthdate])
    end
  end
end
