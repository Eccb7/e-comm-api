class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_id, uniqueness: { scope: :user_id }

  validate :product_availability

  def total_price
    quantity * product.price
  end

  private

  def product_availability
    return unless product && quantity

    unless product.can_fulfill?(quantity)
      errors.add(:quantity, "exceeds available inventory (#{product.inventory_count})")
    end
  end
end
