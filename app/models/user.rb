# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :lockable, :confirmable,
         :timeoutable, :trackable, omniauth_providers: %i[github google_oauth2]

  validates :phone_number, presence: true, uniqueness: true, unless: :github_login?
  validates :birthdate, presence: true, unless: :github_login?
  validate :birthdate_cannot_be_in_the_future
  # Githubユーザー情報をもとに既存のユーザーを検索または新規作成を行う。以前にもGitHubを使用して認証したことがあるか、初めてログインした人かを判別
  # あくまでGitHubを使用して認証した場合の処理なのでbirthdateやphone_numberは記述しない
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize

    user.email = auth.info.email.presence || "#{auth.uid}@github.com"
    user.password ||= Devise.friendly_token[0, 20]

    if user.respond_to?(:skip_confirmation?) && user.confirmed_at.blank?
      Rails.logger.info '✅ skip_confirmation! called for GitHub user'
      user.skip_confirmation!
      user.confirm
    end

    if user.save
      Rails.logger.info "✅ User saved successfully: #{user.inspect}"
    else
      Rails.logger.error "❌ Failed to save user from omniauth: #{user.errors.full_messages}"
    end

    user
  end

  # Gitjubでログインしたときのみバリデーションをスキップ
  def github_login?
    provider == 'github'
  end

  private

  def birthdate_cannot_be_in_the_future
    return unless birthdate.present? && birthdate > Time.zone.today

    Rails.logger.debug I18n.t('activerecord.errors.models.user.attributes.birthdate.in_the_future', default: 'デフォルト')
    errors.add(:birthdate, :in_the_future)
  end
end
