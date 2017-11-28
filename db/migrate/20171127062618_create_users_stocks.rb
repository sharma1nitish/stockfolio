class CreateUsersStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :users_stocks do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
      t.integer :quantity, default: 0
      t.decimal :last_buying_price, precision: 19, scale: 4, default: 0
      t.decimal :average_buying_price, precision: 19, scale: 4, default: 0
      t.decimal :investment, precision: 19, scale: 4, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
