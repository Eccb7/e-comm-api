class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total, precision: 10, scale: 2, null: false
      t.string :status, default: 'pending'
      t.datetime :order_date, null: false

      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :order_date
  end
end
