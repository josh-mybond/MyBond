class Contract < ApplicationRecord
  belongs_to :customer

  TYPE = {
    rental_bond: 0
  }

  def self.new_rental_bond
    contract = Contract.new
    contract.contract_type = TYPE[:rental_bond]
  end


  def value_label
    case self.contract_type
    when TYPE[:rental_bond] then "Rental Bond Amount"
    end
  end

  def initialize_dates_and_amounts
    return if self.value <= 0

    case contract_type
    when TYPE[:rental_bond]

      # First payment
      payment_amount = self.value * 0.05 # 5% of bond
      payment_date   = Time.now
      push_date_and_amount(payment_date, payment_amount)

      residual_amount = self.value - payment_amount
      period          = 14.days
      payments        = 5
      payment_amount  = residual_amount / payments

      while residual_amount > 0 do
        payment_date += period
        push_date_and_amount(payment_date, payment_amount)
        residual_amount -= payment_amount
      end

    end
  end

  private

  def format_date(date)
    date.strftime("%Y-%m-%d")
  end

  def push_date_and_amount(date, amount)
    dates   << format_date(date)
    amounts << amount
  end

end
