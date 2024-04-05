class User < ApplicationRecord
  has_many :orders

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :gender, presence: true
  validates :default_address, presence: true
  validates :default_country, presence: true
  validates :default_city, presence: true
  validates :default_postcode, presence: true
  validates :default_state, presence: true
  #validates :default_phone, presence: true
  #validates :default_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
 # validates :default_payment_method, presence: true

  has_secure_password
end
