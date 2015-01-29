class CreateYearlyContributions < ActiveRecord::Migration
  def change
    create_table :yearly_contributions do |t|
      t.integer :contribution
      t.references :current_amount, index: true

      t.timestamps
    end
  end
end
