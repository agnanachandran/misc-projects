class CurrentAmount < ActiveRecord::Base
  belongs_to :current_age
  has_many :yearly_contributions
end
