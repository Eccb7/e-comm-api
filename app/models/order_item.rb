class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :product_id, uniqueness: { scope: :order_id }

  before_validation :set_unit_price, on: :create
  validate :product_availability

  def total_price
    quantity * unit_price
  end

  private

  def set_unit_price
    self.unit_price ||= product&.price
  end

  def product_availability
    return unless product && quantity

    unless product.can_fulfill?(quantity)
      errors.add(:quantity, "exceeds available inventory (#{product.inventory_count})")
    end
  end
end
