class ContractAgentValidator < ActiveModel::Validator
  def validate(record)

    if record.agent_telephone.blank? and record.agent_email.blank?
      record.errors[:agent_telephone] << "or Agent Email must be completed "
      record.errors[:agent_email]     << "or Agent Telephone must be completed"
    end

    # if record.property_weekly_rent == 0 and record.value == 0
    #   record.errors[:property_weekly_rent] << "Weekly Rent or "
    # end

    if record.end_date < record.start_date
      record.errors[:end_date] << "must be greater than Start Date"
    end

  end
end

class Contract < ApplicationRecord
  belongs_to :customer

  # rental_bond_board_id
  validates :status, :agent_name, :property_address, :property_postcode, :start_date, :end_date, presence: true

  validates_with ContractAgentValidator

  before_save :action_change_of_status

  TYPE = {
    rental_bond: 0
  }

  HISTORY_TYPE = {
    callback: 0
  }

  STATUS = {
    application: 0,
    customer_rejected: 1,
    customer_accepted: 2,
    payment_requested: 3,
    paid: 4,
    cancelled: 5,
    refunded: 6,
    default: 7,
    suspended: 8
  }

  VENDOR = {
    split: 0,
    stripe: 1
  }

  #
  # Status Queries
  #

  def type_to_s
    case self.contract_type
    when TYPE[:rental_bond] then "Rental Bond"
    end
  end

  def status_to_s
    case self.status
    when STATUS[:application]       then "Application"
    when STATUS[:customer_rejected] then "Customer Rejected"
    when STATUS[:customer_accepted] then "Customer Accepted"
    when STATUS[:payment_requested] then "Payment Requested"
    when STATUS[:paid]              then "Paid"
    when STATUS[:cancelled]         then "Cancelled"
    when STATUS[:refunded]          then "Refunded"
    when STATUS[:default]           then "Default"
    when STATUS[:suspended]         then "Suspended"
    end
  end

  def vendor_to_s
    case self.vendor
    when VENDOR[:split]  then "Split"
    when VENDOR[:stripe] then "Stripe"
    end
  end

  def application?
    self.status == STATUS[:application]
  end

  def customer_rejected?
    self.status == STATUS[:customer_rejected]
  end

  def customer_accepted?
    self.status == STATUS[:customer_accepted]
  end

  def payment_requested?
    self.status == STATUS[:payment_requested]
  end

  def paid?
    self.status == STATUS[:paid]
  end

  def cancelled?
    self.status == STATUS[:cancelled]
  end

  def refunded?
    self.status == STATUS[:refunded]
  end

  def default?
    self.status == STATUS[:default]
  end

  def suspended?
    self.status == STATUS[:suspended]
  end

  def has_vendor?
    self.paid? or self.refunded? or self.suspended? or self.default?
  end

  #
  # Status updates
  #

  def application!
    self.status = STATUS[:application]
    self.save
  end

  def customer_rejected!
    self.status = STATUS[:customer_rejected]
    self.save
  end

  def customer_accepted!
    self.status = STATUS[:customer_accepted]

    split_agreement = self.data["split_history"].last


    # Extract & save Split contact_id - this is who we can charge!
    # TODO: error checking.. as if badly formed, will crash :-(
    self.split_authoriser_contact_id = split_agreement[:data][0][:contact_id]
    self.save
  end

  # def split_contact_id
  #   self.data["split_metadata"]["contact_id"]
  # end

  def payment_requested!
    self.status = STATUS[:payment_requested]
    self.save
  end

  def paid!
    self.status = STATUS[:paid]
    self.save
  end

  def cancelled!
    self.status = STATUS[:cancelled]
    self.save
  end

  def refunded!
    self.status = STATUS[:refunded]
    self.save
  end

  def default!
    self.status = STATUS[:default]
    self.save
  end

  def suspended!
    self.status ==STATUS[:suspended]
    self.save
  end


  #
  # vendor
  #

  def split?
    self.vendor == VENDOR[:split]
  end

  def stripe?
    self.vendor == VENDOR[:stripe]
  end

  def split!
    self.vendor = VENDOR[:split]
    self.save
  end

  def stripe!
    self.vendor = VENDOR[:stripe]
    self.save
  end

  def send_pay_by_credit_card_email!
    self.pay_by_credit_card_guid = SecureRandom.uuid
    self.save

    CustomerMailer::pay_by_credit_card(self).deliver_now
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

  #
  # Transactions
  #


  def first_payment!
    # Note: send to split - webhook will handle result
    @split = MBSplit.new
    data   = @split.payment_request(self.property_weekly_rent, self.split_authoriser_contact_id)
    self.push_to_split_history!({ data: data, save: false})
    self.payment_requested!
  end

  def recurring_payment!
    first_payment!
  end

  # TODO -- Deprecate this..
  # def calculate_dates_and_amounts
  #   return if self.value <= 0
  #
  #   case contract_type
  #   when TYPE[:rental_bond]
  #
  #     # First payment
  #     payment_amount = self.value * 0.05 # 5% of bond
  #     payment_date   = Time.now
  #     push_date_and_amount(payment_date, payment_amount)
  #
  #     residual_amount = self.value - payment_amount
  #     period          = 14.days
  #     payments        = 5
  #     payment_amount  = residual_amount / payments
  #
  #     while residual_amount > 0 do
  #       payment_date += period
  #       push_date_and_amount(payment_date, payment_amount)
  #       residual_amount -= payment_amount
  #     end
  #
  #   end
  # end

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
  # Risk
  #

  def risk_check!

    p = Postcode.find_by(postcode: self.property_postcode)

    case
    when p.nil?              then self.errors.add(property_postcode: "Postcode not found.")
    when !p.acceptable_risk? then self.errors.add(property_postcode: "We are not serving this postcode at the moment.")
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
    require 'stripe'
    Stripe.api_key = "sk_test_51HfNuULGovslRiHyNDp7SLbUsHmemafIomCsZvPPrctGRC5p6vPPOvaAVz693Cwyin9htEHoWhCBCSvCHPzd9MPi00hKp82WIy"
    response = Stripe::Checkout::Session.retrieve(self.data["stripe_session_id"])

    case response["payment_status"].to_s
    when "paid" then self.status = STATUS[:paid]
    end

    self.data["stripe_history"] = [] if self.data["stripe_history"].nil?
    self.data["stripe_history"] << JSON.parse(response.to_json)
    self.stripe!
  end

  #
  # Split
  #

  def split_agreement_link(customer)
    split     = MBSplit.new
    agreement = split.split_unassigned_agreement(self)
    link      = split.add_link_customisation(self, customer, agreement["data"]["link"])

    self.push_to_split_history!({ data: agreement, save: true })

    return agreement, link
  end

  #
  # Status updates
  #


  def push_to_split_history!(options)
    self.data = {} if self.data.nil?
    self.data["split_history"] = [] if self.data["split_history"].nil?
    self.data["split_history"] << options[:data]
    self.save if options[:save] == true
  end

  #
  # Handle any change of status
  #

  # Note: before save is run after validations pass
  def action_change_of_status
    # puts "business_logic: 1"
    return if self.status_was == self.status
    # puts "business_logic: 2"

    case self.status
    when STATUS[:application]
      puts "action_change_of_status: Application"
    when STATUS[:customer_rejected]
      puts "action_change_of_status: Customer Rejected"
    when STATUS[:customer_accepted]
      puts "action_change_of_status: Customer Accepted"
    when STATUS[:payment_requested]
      puts "action_change_of_status: Payment Requested"
    when STATUS[:paid]
      puts "action_change_of_status: Paid"
    when STATUS[:cancelled]
      puts "action_change_of_status: Cancelled"
    when STATUS[:refunded]
      puts "action_change_of_status: Refunded"
    when STATUS[:default]
      puts "action_change_of_status: Default"
    when STATUS[:suspended]
      puts "action_change_of_status: Suspended"
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
