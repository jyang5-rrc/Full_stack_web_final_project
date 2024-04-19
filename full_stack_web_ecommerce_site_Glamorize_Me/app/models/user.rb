class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable
  has_many :orders

  has_one :cart, dependent: :destroy

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

  # Define searchable associations for Ransack
  def self.ransackable_attributes(auth_object = nil)
    # List of attributes you want to be searchable
    # Exclude sensitive attributes to prevent unauthorized search access
    ["email", "id", "id_value", "name", "age", "gender", "default_address", "default_city", "default_country", "default_postcode", "default_state"]

  end

  # Define searchable associations for Ransack
  def self.ransackable_associations(auth_object = nil)
    # List the associations you want to be searchable.
    # Exclude any associations that could lead to sensitive information being exposed.
    ["orders"] # Adjust this list based on your actual associations
  end


end
