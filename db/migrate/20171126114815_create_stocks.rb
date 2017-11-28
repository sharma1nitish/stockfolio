class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :bse_code
      t.string :symbol
      t.decimal :last_buying_price, precision: 19, scale: 4, default: 0

      t.timestamps
    end
  end
end
