class Transaction < ApplicationRecord
  belongs_to :users_stock

  validates :users_stock, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_per_unit, presence: true, numericality: { greater_than: 0 }
  # validates :transacted_at, presence: true, format: { with: /\w{3}\ \d{2}\, \d{4}/, message: 'must be in the following format: mmm dd, yyyy' }
  validates :transaction_type, presence: true
  validate :sale_is_not_more_than_purchase

  enum transaction_type: [:buy, :sell]

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

  def sale_is_not_more_than_purchase

    errors.add(:quantity, 'cannot exceed total quantity of stocks') if sell? && quantity > users_stock.quantity
  end
end
