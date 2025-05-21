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
  validates :password, presence: true, length: { minimum: 6 }, on: :create, unless: :github_login?

  # ユーザーのツイート
  # ツイートの削除時に関連する画像も削除する
  has_one_attached :avatar_image
  has_one_attached :header_image
  has_one_attached :attach_image
  has_many :tweets, dependent: :destroy, inverse_of: :user

  has_many :comments, dependent: :destroy
  has_many :commented_tweets, through: :comments, source: :tweet
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

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
  # リツイートだけを取得するアソシエーション。あるユーザーがリツイートしてツイートを一覧表示するために使用する。
  has_many :retweet_tweets, -> { where.not(retweeted_from_id: nil) }, class_name: 'Tweet', dependent: :destroy,
                                                                      foreign_key: 'retweeted_from_id',
                                                                      inverse_of: :retweeted_from
  # ユーザーのリツイートを取得するためのアソシエーション。あるユーザーがリツイートしたツイートを一覧表示するために使用する。
  has_many :retweets, class_name: 'Tweet', foreign_key: 'retweeted_from_id', dependent: :destroy,
                      inverse_of: :retweeted_from

  # ユーザーのいいねを取得するためのアソシエーション。あるユーザーがいいねしたツイートを一覧表示するために使用する。
  has_many :liked_tweets, through: :likes, source: :tweet

  # Omniauthからの情報をもとにユーザーを作成または更新

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

  def following?(other_user)
    followings.include?(other_user)
  end

  private

  def birthdate_cannot_be_in_the_future
    return unless birthdate.present? && birthdate > Time.zone.today

    Rails.logger.debug I18n.t('activerecord.errors.models.user.attributes.birthdate.in_the_future', default: 'デフォルト')
    errors.add(:birthdate, :in_the_future)
  end
end
