class User < ApplicationRecord
  has_secure_password

  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def cart_total
    cart_items.joins(:product).sum("products.price * cart_items.quantity")
  end
end
