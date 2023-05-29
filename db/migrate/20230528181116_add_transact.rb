class AddTransact < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'

    create_table :transacts, id: :uuid, force: :cascade do |t|
      t.integer :amount
      t.integer :status, null: false
      t.string :customer_email
      t.string :customer_phone
      t.string :type, null: false

      t.references :user, null: false, foreign_key: true
      t.references :transact, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
