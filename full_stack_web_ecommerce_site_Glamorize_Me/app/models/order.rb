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


end
