class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :restrict_with_error
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :inventory_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 1000 }

  scope :available, -> { where("inventory_count > 0") }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :price_range, ->(min, max) { where(price: min..max) }

  def available?
    inventory_count > 0
  end

  def can_fulfill?(quantity)
    inventory_count >= quantity
  end
end
