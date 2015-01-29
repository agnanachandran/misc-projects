class CurrentAge < ActiveRecord::Base
  belongs_to :portfolio_type
  has_many :current_amounts
end
