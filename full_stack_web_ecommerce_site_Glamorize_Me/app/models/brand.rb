class Brand < ApplicationRecord
  has_many :products

  validates :brand_name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']
  end

  def self.ransackable_associations(auth_object = nil)
    # 'products' is included to allow searches that traverse through the Category -> Products relationship.
    ["products"]
  end
end
