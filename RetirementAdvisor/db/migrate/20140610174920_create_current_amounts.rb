class CreateCurrentAmounts < ActiveRecord::Migration
  def change
    create_table :current_amounts do |t|
      t.integer :amount
      t.references :current_age, index: true

      t.timestamps
    end
  end
end
