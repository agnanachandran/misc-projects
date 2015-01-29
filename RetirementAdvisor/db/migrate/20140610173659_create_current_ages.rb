class CreateCurrentAges < ActiveRecord::Migration
  def change
    create_table :current_ages do |t|
      t.integer :age
      t.references :portfolio_type, index: true

      t.timestamps
    end
  end
end
