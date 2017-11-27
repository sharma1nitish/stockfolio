class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :users_stock, foreign_key: true
      t.integer :quantity
      t.decimal :price_per_unit
      t.date :transacted_at
      t.integer :transaction_type, default: 0
      t.decimal :brokerage
      t.boolean :is_brokerage_percentage
      t.boolean :is_brokerage_amount

      t.timestamps
    end
  end
end
