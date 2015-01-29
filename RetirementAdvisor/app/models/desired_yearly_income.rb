class DesiredYearlyIncome < ActiveRecord::Base
  belongs_to :yearly_contribution
  has_one :retirement_age
end
