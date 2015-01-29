json = ActiveSupport::JSON.decode(File.read('db/seeds/retirement-data.json'))

json.each do |portfolio_type, age_map|
  portfolio = PortfolioType.create!(:type_name => portfolio_type)
  i = 0
  age_map.each do |current_age, current_amount_map|
    i+=1
    puts age_map.length
    puts i/age_map.length
    created_current_age = portfolio.current_ages.create!(:age => current_age.to_i)
    current_amount_map.each do |current_amount, yearly_contributions_map|
      created_current_amount = created_current_age.current_amounts.create!(:amount => current_amount.to_i)
      yearly_contributions_map.each do |contribution, desired_yearly_income_map|
        created_yearly_contribution = created_current_amount.yearly_contributions.create!(:contribution => contribution.to_i)
        desired_yearly_income_map.each do |income, retirement_age|
          created_desired_yearly_income = created_yearly_contribution.desired_yearly_incomes.create!(:income => income.to_i)
          created_desired_yearly_income.retirement_age = RetirementAge.create!(:retirement_age => retirement_age)
        end
      end
    end
  end
end
