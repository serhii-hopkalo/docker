class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.text :description
      t.string :email, null: false, unique: true
      t.integer :status, default: 0
      t.string :type
      t.integer :total_transaction_sum, default: 0, null: false

      t.timestamps

      t.index [:email], name: :index_on_email, unique: true
    end
  end
end
