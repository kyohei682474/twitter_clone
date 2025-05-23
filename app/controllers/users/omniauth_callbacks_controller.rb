# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        ::TestMailer.send_email(@user.email).deliver_later
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format? # HTMLを使用した画面遷移の時のみフラッシュメッセージを挿入。 # rubocop:disable Layout/LineLength

      else
        redirect_to new_user_registration_url, alert: 'GitHubでの認証に失敗しました。'
      end
    end
    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:twitter]

    # You should also create an action method in this controller like this:
    # def twitter
    # end

    # More info at:
    # https://github.com/heartcombo/devise#omniauth

    # GET|POST /resource/auth/twitter
    # def passthru
    #   super
    # end

    # GET|POST /users/auth/twitter/callback
    # def failure
    #   super
    # end

    # protected

    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end
  end
end
