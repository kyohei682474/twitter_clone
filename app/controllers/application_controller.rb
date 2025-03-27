# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # rubocop:disable Hc/RailsSpecificActionName
  def after_sign_in_path_for(_resource)
    root_path # ログイン後にリダイレクトするパス
  end

  def after_sign_up_path_for(_resource)
    root_path # サインアップ後にリダイレクトするパス
  end
  # rubocop:enable Hc/RailsSpecificActionName

  def after_sign_in_path_for(_resource)
    root_path  # トップページにリダイレクト
  end

  def after_sign_up_path_for(_resource)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email phone_number birthdate])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email phone_number birthdate])
  end
end
