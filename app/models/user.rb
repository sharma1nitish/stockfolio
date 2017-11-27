class User < ApplicationRecord
  has_many :users_stocks
  has_many :stocks, through: :users_stocks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
