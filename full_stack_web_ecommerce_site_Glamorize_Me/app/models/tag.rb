class Tag < ApplicationRecord
  has_many :product_tags
  has_many :products, through: :product_tags

  validates :tag_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    super - ['id', 'created_at', 'updated_at']
  end

  def self.ransackable_associations(auth_object = nil)
    # 'products' is included to allow searches that traverse through the Category -> Products relationship.
    ["product_tag"]
  end

end
