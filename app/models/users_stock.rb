class UsersStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  has_many :transactions, dependent: :destroy

  validates :user_id, presence: true
  validates :stock_id, presence: true, uniqueness: { scope: :user_id }
  validates :investment, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :last_buying_price, presence: true, numericality: { greater_than: 0 }

  before_validation :set_investment_and_average_buying_price, on: :create

  def set_investment_and_average_buying_price
    self.investment = last_buying_price * quantity
    self.average_buying_price = last_buying_price
  end
end
