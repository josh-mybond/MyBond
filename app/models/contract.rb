class ContractAgentValidator < ActiveModel::Validator
  def validate(record)

    if record.agent_telephone.blank? and record.agent_email.blank?
      record.errors[:agent_telephone] << "or Agent Email must be completed "
      record.errors[:agent_email]     << "or Agent Telephone must be completed"
    end

    if record.property_weekly_rent == 0 and record.value == 0
      record.errors[:property_weekly_rent] << "Weekly Rent or "
      # errors[:base] << "This person is invalid because ..."
    end

  end
end

class Contract < ApplicationRecord
  belongs_to :customer


  validates :status, :agent_name, :property_address, :property_postcode, presence: true

# #<Contract id: nil, contract_type: 0, customer_id: nil,
# created_at: nil, updated_at: nil, status: 0,
# agent_name: nil, agent_telephone: nil, agent_email: nil,
#  property_weekly_rent: nil, property_address: nil,
#  property_postcode: nil, property_iso_country_code: "AU",
#  rental_bond_board_id: nil>


  TYPE = {
    rental_bond: 0
  }

  HISTORY_TYPE = {
    callback: 0
  }

  STATUS = {
    open: 0,
    active: 1,
    paid: 2,
    refunded: 3,
    cancelled: 4,
    default: 5,
    suspended: 6,
    awaiting_customer_acceptance: 10,
    awaiting_payment_acceptance: 11
  }

  #
  # Status
  #

  def open?
    self.status == STATUS[:open]
  end

  def active?
    self.status == STATUS[:active]
  end

  def paid?
    self.status == STATUS[:paid]
  end

  def refunded?
    self.status == STATUS[:refunded]
  end

  def cancelled?
    self.status == STATUS[:cancelled]
  end

  def default?
    self.status == STATUS[:default]
  end

  #
  #
  #

  def self.new_rental_bond
    contract = Contract.new
    contract.contract_type = TYPE[:rental_bond]
    contract.setup_for_type
    contract
  end

  def setup_for_type
    case contract_type
    when TYPE[:rental_bond]
      # TODO: should probably have own tables for these..
      self.data = {}
      self.data["agent"]    = {
        name: "",
        email: "",
        telephone: ""
      }
      self.data["property"] = {
        address: ""
      }
    end
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

  #
  # Stripe
  #

  def create_stripe_session!(email)
    Stripe.api_key = "sk_test_51HfNuULGovslRiHyNDp7SLbUsHmemafIomCsZvPPrctGRC5p6vPPOvaAVz693Cwyin9htEHoWhCBCSvCHPzd9MPi00hKp82WIy"

    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'aud',
          product_data: {
            name: 'My Bond',
          },
          unit_amount: self.property_weekly_rent * 100,
        },
        quantity: 1,
      }],
      mode: 'payment',
      # For now leave these URLs as placeholder values.
      #
      # Later on in the guide, you'll create a real success page, but no need to
      # do it yet.
      success_url: 'http://localhost:3005/payment_success',
      cancel_url: 'http://localhost:3005/payment_failed',
      client_reference_id: self.id,
      customer_email: email
    })

    self.data = {} if self.data.nil?
    self.data["stripe_session_id"] = session.id
    self.save

    session
  end

  def update_from_stripe_session!
    # Retrieve
    require 'stripe'
    Stripe.api_key = "sk_test_51HfNuULGovslRiHyNDp7SLbUsHmemafIomCsZvPPrctGRC5p6vPPOvaAVz693Cwyin9htEHoWhCBCSvCHPzd9MPi00hKp82WIy"
    response = Stripe::Checkout::Session.retrieve(self.data["stripe_session_id"])

    case response["payment_status"]
    when "paid" then self.status == STATUS[:paid]
    end

    self.data["history"] = [] if self.data["history"].nil?
    self.data["history"] << JSON.parse(response.to_json)
    self.save!

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
