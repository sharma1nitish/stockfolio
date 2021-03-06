class Transaction < ApplicationRecord
  belongs_to :users_stock

  validates :users_stock, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_per_unit, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true
  validate :sale_is_not_more_than_purchase

  enum transaction_type: [:buy, :sell]

  before_create :check_if_sale_transaction_for_inactive_users_stock
  after_create :refresh_users_stock!

  def investment
    price_per_unit * quantity
  end

  def change_in_quantity
    buy? ? quantity : -quantity
  end

  def change_in_investment
    if buy?
      investment
    elsif sell?
      - (quantity * users_stock.average_buying_price)
    end
  end

  def refresh_users_stock!
    return if users_stock.transactions.count == 1

    users_stock.quantity += change_in_quantity

    users_stock.deactivate! && return if sell? && users_stock.quantity.zero?

    users_stock.last_buying_price = price_per_unit if buy?
    users_stock.investment += change_in_investment
    users_stock.average_buying_price = users_stock.investment / users_stock.quantity
    users_stock.save!
  end

  def check_if_sale_transaction_for_inactive_users_stock
    return if users_stock.active?

    sell? ? errors.add(:transaction_type, 'Stock must be bought before selling') : users_stock.active!
  end

  def sale_is_not_more_than_purchase
    if sell?
      errors.add(:transaction_type, 'Stock must be bought before selling') if users_stock.inactive?
      errors.add(:quantity, 'Quantity cannot exceed total quantity of stocks') if quantity > users_stock.quantity
    end
  end
end
