class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true
      t.references :stock, foreign_key: true
      t.integer :quantity
      t.decimal :price_per_unit
      t.date :transacted_at
      t.integer :transaction_type
      t.decimal :brokerage
      t.boolean :is_brokerage_percentage
      t.boolean :is_brokerage_amount

      t.timestamps
    end
  end
end
