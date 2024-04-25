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

  attr_accessor :use_default_address


  def self.ransackable_attributes(auth_object = nil)
    # List of attributes you want to be searchable
    # Ensure you exclude sensitive information like user passwords or tokens
    ["created_at", "id", "order_date", "shipping_address", "shipping_city", "shipping_country", "shipping_postcode", "shipping_state", "status_id", "tax_rate_id", "updated_at", "user_id"]
  end

  def subtotal
    order_products.sum { |op| op.quantity * op.price_at_time_of_order }
  end

  def tax_total
    # Fetch the tax rate from the related TaxRate model
    current_tax_rate = self.tax_rate

    # Calculate total tax based on the applicable tax rates
    pst_total = subtotal * current_tax_rate.pst
    gst_total = subtotal * current_tax_rate.gst
    hst_total = subtotal * current_tax_rate.hst

    pst_total + gst_total + hst_total
  end

  def final_total
    subtotal + tax_total
  end

end
