class Order < ApplicationRecord
  belongs_to :user
  belongs_to :status
  belongs_to :tax_rate

  has_one :tracking
  has_many :order_products
  has_many :products, through: :order_products

  validates :user_id, presence: true
  validates :status_id, presence: true
  validates :tax_rate_id, presence: true
  validates :order_date, presence: true
  validates :shipping_address, presence: true
  validates :shipping_city, presence: true
  validates :shipping_state, presence: true
  validates :shipping_country, presence: true
  validates :shipping_postcode, presence: true

  def self.ransackable_attributes(auth_object = nil)
    # List of attributes you want to be searchable
    # Ensure you exclude sensitive information like user passwords or tokens
    ["created_at", "id", "order_date", "shipping_address", "shipping_city", "shipping_country", "shipping_postcode", "shipping_state", "status_id", "tax_rate_id", "updated_at", "user_id"]
  end

end
