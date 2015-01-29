class StaticPagesController < ApplicationController
  def submit
    portfolio_type = params[:portfolio_type]
    current_age = params[:current_age]
    current_amount = params[:current_amount]
    yearly_contribution = params[:yearly_contribution]
    desired_yearly_income = params[:desired_yearly_income]

    portfolio = PortfolioType.find_by_type_name(portfolio_type)
    age = CurrentAge.find_by portfolio_type_id: portfolio.id, age: current_age
    amount = CurrentAmount.find_by current_age_id: age.id, amount: current_amount
    contribution = YearlyContribution.find_by current_amount_id: amount.id, contribution: yearly_contribution
    income = DesiredYearlyIncome.find_by yearly_contribution_id: contribution.id, income: desired_yearly_income
    @retirement_age_value = (RetirementAge.find_by desired_yearly_income_id: income.id).retirement_age
    Rails.logger.debug @retirement_age_value
    define_instance_vars
    render 'submit'
  end

  def home 
    define_instance_vars
  end

  def define_instance_vars
    @retirement_age = ''

    @portfolio_types = PortfolioType.all
    @current_ages = CurrentAge.where('portfolio_type_id = 1')
    @current_amounts = CurrentAmount.where('current_age_id = 1')
    @yearly_contributions = YearlyContribution.where('current_amount_id = 1')
    @desired_yearly_incomes = DesiredYearlyIncome.where('yearly_contribution_id = 1')
    @portfolio_types_values = []
    @current_ages_values = []
    @current_amounts_values = []
    @yearly_contributions_values = []
    @desired_yearly_incomes_values = []

    @portfolio_types.map { |type|
      @portfolio_types_values << type.type_name
    }
    @current_ages.map { |age|
      @current_ages_values << age.age
    }
    @current_amounts.map { |amount|
      @current_amounts_values << amount.amount
    }
    @yearly_contributions.map { |contribution|
      @yearly_contributions_values << contribution.contribution
    }
    @desired_yearly_incomes.map { |income|
      @desired_yearly_incomes_values << income.income
    }

    @portfolio_types_values.sort!
    @current_ages_values.sort!
    @current_amounts_values.sort!
    @yearly_contributions_values.sort!
    @desired_yearly_incomes_values.sort!
  end
end

