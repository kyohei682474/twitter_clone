class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :lockable,
         :timeoutable, :trackable, omniauth_providers: %i[github google_oauth2]

  validates :phone_number, presence: true, uniqueness: true
  validates :birthdate, presence: true
  validate :birthdate_cannot_be_in_the_future

  private

  def birthdate_cannot_be_in_the_future
    return unless birthdate.present? && birthdate > Date.today

    puts I18n.t('activerecord.errors.models.user.attributes.birthdate.in_the_future', default: 'デフォルト')
    errors.add(:birthdate, :in_the_future)
  end
end
