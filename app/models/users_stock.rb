class UsersStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :investment, presence: true
  validates :quantity, presence: true
  validates :last_buying_price, presence: true
end
