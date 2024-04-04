class Role < ApplicationRecord
  has_many :administrators

  validates :name, presence: true, uniqueness: true
end
