class Stock < ApplicationRecord
  has_many :users_stocks
  has_many :users, through: :users_stocks

  validates :name, presence: true
  validates :symbol, presence: true
  validates :bse_code, presence: true, uniqueness: true
  validates :last_buying_price, presence: true

  def self.refresh_prices_of_all!
    find_each(&:refresh_price!)
  end

  def current_price
    StockQuote::Stock.quote("BOM:#{code}").l
  end

  def refresh_price!
    last_buying_price = BigDecimal(StockQuote::Stock.quote("BOM:#{code}").l)
    save!
  end
end
