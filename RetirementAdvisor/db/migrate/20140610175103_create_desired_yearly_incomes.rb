class CreateDesiredYearlyIncomes < ActiveRecord::Migration
  def change
    create_table :desired_yearly_incomes do |t|
      t.integer :income
      t.references :yearly_contribution, index: true

      t.timestamps
    end
  end
end
