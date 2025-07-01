module UserOmniauthable
  extend ActiveSupport::Concern

  class_methods do # rubocop:disable Metrics/BlockLength
    def from_omniauth(auth)
      user = first_or_initialize(auth)
      if user.new_record? && (existing_user = link_with_existing_user(auth))
        return existing_user
      end

      set_user_attribute(user, auth)

      if user.save
        user.confirm if user.respond_to?(:confirm) && user.confirmed_at.blank?
        user
      else
        Rails.logger.error("GitHubログインでユーザー保存に失敗: #{user.errors.full_messages}")
        nil
      end
    end

    def first_or_initialize(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_initialize
    end

    def link_with_existing_user(auth)
      existing_user = find_by(email: auth.info.email)
      return unless existing_user

      if existing_user.update(provider: auth.provider, uid: auth.uid)
        existing_user
      else
        Rails.logger.error("GitHub連携に失敗: #{existing_user.errors.full_messages}")
        nil
      end
    end

    def set_user_attribute(user, auth)
      user.email = auth.info.email.presence || "#{auth.uid}@github.com"
      user.name = auth.info.name.presence || 'GitHubユーザー'
      user.provider = auth.provider
      user.uid = auth.uid
      user.password ||= Devise.friendly_token[0, 20]
      user.phone_number ||= '0000000000' # ★追加
      user.birthdate ||= Date.new(2000, 1, 1) # ★追加
    end
  end
end
