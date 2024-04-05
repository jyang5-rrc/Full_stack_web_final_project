class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :category
  belongs_to :product_type

  has_many :order_products
  has_many :orders, through: :order_products
  has_many :comments
  has_many :product_tags
  has_many :tags, through: :product_tags

  validates :product_name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 1000 }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  # search method
  def self.search(term, search_option)
    if term.present?
      case search_option
      when 'product'
        where('product_name LIKE ?', "%#{term}%")
      when 'category'
        joins(:category).where('category_name LIKE ?', "%#{term}%") #:category is the association name
      when 'brand'
        joins(:brand).where('brand_name LIKE ?', "%#{term}%")#brand_name is the column name
      when 'product_type'
        joins(:product_type).where('product_type_name LIKE ?', "%#{term}%")#product_type_name is the column name

      end

    end
  end
end
