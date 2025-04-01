# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :lockable, :confirmable,
         :timeoutable, :trackable, omniauth_providers: %i[github google_oauth2]

  validates :phone_number, presence: true, uniqueness: true
  validates :birthdate, presence: true
  validate :birthdate_cannot_be_in_the_future

  # Githubユーザー情報をもとに既存のユーザーを検索または新規作成を行う。以前にもGitHubを使用して認証したことがあるか、初めてログインした人かを判別
  # あくまでGitHubを使用して認証した場合の処理なのでbirthdateやphone_numberは記述しない
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.uid}github.com" # GitHubがメールアドレスを提供しない場合は,uidを使用する
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def birthdate_cannot_be_in_the_future
    return unless birthdate.present? && birthdate > Time.zone.today

    Rails.logger.debug I18n.t('activerecord.errors.models.user.attributes.birthdate.in_the_future', default: 'デフォルト')
    errors.add(:birthdate, :in_the_future)
  end
end
