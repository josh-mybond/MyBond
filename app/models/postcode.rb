class Postcode < ApplicationRecord
  validates :postcode, :risk, :risk_limit, presence: true
  validates :postcode, uniqueness: true

  def acceptable_risk?
    self.risk >= self.risk_limit
  end

end
