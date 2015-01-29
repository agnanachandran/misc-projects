class YearlyContribution < ActiveRecord::Base
  belongs_to :current_amount
  has_many :desired_yearly_incomes
end
