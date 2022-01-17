class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.name_length}

  validates :email, presence: true,
                    length: {maximum: Settings.email_length},
                    format: {with: Settings.email_regexp},
                    uniqueness: true

  has_secure_password

  validates :password, presence: true,
                       length: {minimum: Settings.pass_min_length}

  private
  def downcase_email
    email.downcase!
  end
end
