class UsersStock < ApplicationRecord
  attr_accessor :transaction_type

  belongs_to :user
  belongs_to :stock

  has_many :transactions, dependent: :destroy

  validates :user_id, presence: true
  validates :stock_id, presence: true, uniqueness: { scope: :user_id }
  validates :investment, presence: true
  validates :quantity, presence: true
  validates :last_buying_price, presence: true
  validate :first_transaction_is_not_a_sale

  enum status: [:active, :inactive]

  before_validation :set_investment_and_average_buying_price, on: :create

  def set_investment_and_average_buying_price
    self.investment = last_buying_price * quantity
    self.average_buying_price = last_buying_price
  end

  def deactivate!
    self.last_buying_price = 0
    self.average_buying_price = 0
    self.investment = 0
    self.status = :inactive
    save!
  end

  def first_transaction_is_not_a_sale
    errors.add(:transaction_type, 'Stock must be bought before selling') if new_record? && transaction_type == 'sell'
  end
end
