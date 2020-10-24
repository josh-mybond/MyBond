class Postcode < ApplicationRecord
  validates :postcode, :risk, :risk_limit, presence: true
  validates :postcode, uniqueness: true

  def acceptable_risk?
    self.risk >= self.risk_limit
  end

  # Note:
  # This is not in a validation as if the risk for a postcode changes
  # We want to be able to save without causing a validation error
  def risk_check!
    if !acceptable_risk?
      self.errors.add(property_postcode: "We are not serving this postcode at the moment.")
    end
  end

end
