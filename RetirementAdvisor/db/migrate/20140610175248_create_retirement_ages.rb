class CreateRetirementAges < ActiveRecord::Migration
  def change
    create_table :retirement_ages do |t|
      t.integer :retirement_age
      t.references :desired_yearly_income, index: true

      t.timestamps
    end
  end
end
