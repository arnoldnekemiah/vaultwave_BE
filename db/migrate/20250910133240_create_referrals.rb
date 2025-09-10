class CreateReferrals < ActiveRecord::Migration[8.0]
  def change
    create_table :referrals do |t|
      t.references :referrer, null: false, foreign_key: { to_table: :users }
      t.references :referred, null: false, foreign_key: { to_table: :users }
      t.datetime :clicked_at
      t.datetime :converted_at

      t.timestamps
    end
  end
end
