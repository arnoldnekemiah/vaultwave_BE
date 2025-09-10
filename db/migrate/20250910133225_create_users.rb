class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :wallet_address, null: false
      t.integer :waitlist_position
      t.string :referral_code
      t.integer :referred_by_user_id

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :referral_code, unique: true
    add_foreign_key :users, :users, column: :referred_by_user_id
  end
end
