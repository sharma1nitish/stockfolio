class Transaction < ApplicationRecord
  belongs_to :users_stock

  validates :users_stock, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_per_unit, presence: true, numericality: { greater_than: 0 }
  # validates :transacted_at, presence: true
  validates :transaction_type, presence: true

  enum transaction_type: [:buy, :sell]

  after_create :refresh_users_stock!

  def investment
    amount = price_per_unit * quantity
    buy? ? amount : -amount
  end

  def change_in_quantity
    buy? ? quantity : -quantity
  end

  def refresh_users_stock!
    return if users_stock.transactions.count == 1

    new_quantity = users_stock.quantity + change_in_quantity
    new_investment = users_stock.investment + investment

    users_stock.quantity = new_quantity
    users_stock.last_buying_price = price_per_unit if buy?
    users_stock.average_buying_price = new_investment / new_quantity
    users_stock.investment = new_investment
    users_stock.save
  end
end
