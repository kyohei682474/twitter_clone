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
  validates :name, length: { maximum: 50 }, allow_nil: true
  validates :email, presence: true, uniqueness: true, unless: :github_login?
  validates :password, presence: true, length: { minimum: 6 }, unless: :github_login?

  # ユーザーのツイート
  # ツイートの削除時に関連する画像も削除する
  has_one_attached :image
  has_many :tweets, dependent: :destroy
  # フォローしている人
  has_many :active_relationships, foreign_key: :follower_id, class_name: 'Relationship', dependent: :destroy,
                                  inverse_of: :follower
  has_many :followings, through: :active_relationships, source: :followed
  # フォローしてくれている人
  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship', dependent: :destroy,
                                   inverse_of: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  # Githubユーザー情報をもとに既存のユーザーを検索または新規作成を行う。以前にもGitHubを使用して認証したことがあるか、初めてログインした人かを判別
  # あくまでGitHubを使用して認証した場合の処理なのでbirthdateやphone_numberは記述しない
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize

    user.email = auth.info.email.presence || "#{auth.uid}@github.com"
    user.password ||= Devise.friendly_token[0, 20]

    user.confirm if user.save && user.respond_to?(:confirm) && user.confirmed_at.blank?

    user
  end

  # Gitjubでログインしたときのみバリデーションをスキップ
  def github_login?
    provider == 'github'
  end

  def display_name
    name.presence || email.split('@').first
  end

  private

  def birthdate_cannot_be_in_the_future
    return unless birthdate.present? && birthdate > Time.zone.today

    Rails.logger.debug I18n.t('activerecord.errors.models.user.attributes.birthdate.in_the_future', default: 'デフォルト')
    errors.add(:birthdate, :in_the_future)
  end
end
