class CreatePortfolioTypes < ActiveRecord::Migration
  def change
    create_table :portfolio_types do |t|
      t.string :type_name

      t.timestamps
    end
  end
end
