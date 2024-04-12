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

  # Define searchable associations for Ransack
  def self.ransackable_attributes(auth_object = nil)
    # List of attributes you want to be searchable
    # Exclude sensitive attributes to prevent unauthorized search access
    ["product_name", "price", "description", "rating", "created_at", "brand_id", "category_id", "product_type_id"]
  end

  # Define searchable associations for Ransack
  def self.ransackable_associations(auth_object = nil)
    # List the associations you want to be searchable.
    # Exclude any associations that could lead to sensitive information being exposed.
    ["brand", "category", "product_type", "product_tag"] # Adjust this list based on your actual associations
  end

  # Ransacker to search products by category name
  ransacker :category_name, formatter: proc { |v|
    Category.where("name ILIKE ?", "%#{v}%").pluck(:id)
  } do |parent|
    parent.table[:category_id]
  end

  ransacker :product_type_name, formatter: proc { |v|
    ProductType.where("name ILIKE ?", "%#{v}%").pluck(:id)
  } do |parent|
    parent.table[:product_type_id]
  end

end
