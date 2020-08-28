class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable
  VALID_EMAIL_REGEX = Settings.email_regex
  PERMIT_SIGNUP_ATTRIBUTES = %i(name email password password_confirmation)
                             .freeze
  PERMIT_CREATE_ATTRIBUTES = %i(name email password password_confirmation role)
                             .freeze

  validates :name, presence: true
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}

  before_save :downcase_email

  enum role: {user: 0, admin: 1, support: 2, logistic: 3}, _suffix: true

  private

  def downcase_email
    email.downcase!
  end
end
