class CreateStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.string :code
      t.string :name
      t.decimal :last_buying_price, precision: 19, scale: 4

      t.timestamps
    end
  end
end
