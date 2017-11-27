class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :last_buying_price, presence: true
end
