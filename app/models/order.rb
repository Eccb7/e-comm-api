class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending confirmed shipped delivered cancelled] }
  validates :order_date, presence: true

  before_validation :set_order_date, on: :create
  before_validation :calculate_total

  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(order_date: :desc) }

  def can_be_cancelled?
    %w[pending confirmed].include?(status)
  end

  private

  def set_order_date
    self.order_date ||= Time.current
  end

  def calculate_total
    self.total = order_items.sum { |item| item.quantity * item.unit_price }
  end
end
