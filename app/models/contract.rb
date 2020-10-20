class Contract < ApplicationRecord
  belongs_to :customer

  TYPE = {
    rental_bond: 0
  }

  HISTORY_TYPE = {
    callback: 0
  }

  STATUS = {
    open: 0,
    active: 1,
    paid_in_full: 2,
    refunded: 3,
    cancelled: 4,
    default: 5,
    suspended: 6,
    awaiting_customer_acceptance: 10,
    awaiting_payment_acceptance: 11
  }

  def self.new_rental_bond
    contract = Contract.new
    contract.contract_type = TYPE[:rental_bond]
  end

  def calculate_dates_and_amounts
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


  def update_from_callback!(json)
    # {"api_identifier"=>"test_api_identifier",
    #  "status"=>"1",
    #  "repayments"=>[{"id"=>1349, "status"=>"Approved", "date"=>"2019-12-15T17:38:10.656+11:00", "amount"=>7600}, {"id"=>1360, "status"=>"Dishonoured", "date"=>"2019-12-29T20:15:00.000+11:00", "amount"=>7600}, {"id"=>2340, "status"=>"Dishonoured", "date"=>"2020-01-12T09:15:00.000+11:00", "amount"=>7600}, {"id"=>2341, "status"=>"Dishonoured", "date"=>"2020-01-26T09:15:00.000+11:00", "amount"=>7600}, {"id"=>2637, "status"=>"Approved", "date"=>"2020-02-05T09:15:00.000+11:00", "amount"=>7600}, {"id"=>2641, "status"=>"Approved", "date"=>"2020-02-12T09:15:00.000+11:00", "amount"=>7600}, {"id"=>2642, "status"=>"Dishonoured", "date"=>"2020-02-26T09:15:00.000+11:00", "amount"=>7600}, {"id"=>2643, "status"=>"Approved", "date"=>"2020-03-11T09:15:00.000+11:00", "amount"=>7600}, {"id"=>3152, "status"=>"Dishonoured", "date"=>"2020-03-25T09:15:00.000+11:00", "amount"=>7600}, {"id"=>3330, "status"=>"Approved", "date"=>"2020-03-27T10:39:58.461+11:00", "amount"=>7600}]}

    case json["status"].to_i # force to integer
    when  0 then self.status = STATUS[:open]
    when  1 then self.status = STATUS[:active]
    when  2 then self.status = STATUS[:paid_in_full]
    when  3 then self.status = STATUS[:refunded]
    when  4 then self.status = STATUS[:cancelled]
    when  5 then self.status = STATUS[:default]
    when  6 then self.status = STATUS[:suspended]
    when 10 then self.status = STATUS[:awaiting_customer_acceptance]
    when 11 then self.status = STATUS[:awaiting_payment_acceptance]
    end

    update_history!(TYPE[:callback], json)
  end

  def update_history!(type, data)
    check_history

    object = {
      type: type,
      date: DateTime.now,
      data: data
    }

    self.data["history"] << object
    self.save!
  end



  def value_label
    case self.contract_type
    when TYPE[:rental_bond] then "Rental Bond Amount"
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

  def check_history
    self.data = {} if self.data.nil?
    self.data["history"] = [] if self.data["history"].nil?
  end

end
