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

  # TODO: refactor to seperate model with versions
  ESTABLISHMENT_FEE     = 0.05
  MONTHLY_INTEREST_RATE = 0.02

  TYPE = {
    new_rental_bond: 0,
    existing_rental_bond: 1
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
    when p.nil?              then self.errors.add(:property_postcode, "Postcode not found.")
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
  # Calculators
  #

  # ESTABLISHMENT_FEE     = 0.05
  # MONTHLY_INTEREST_RATE = 0.02

  if Rails.env.development?
    def self.test
      c = Contract.new
      c.rental_bond = 2400
      c.property_weekly_rent = 600
      c.calculate_new_bond
    end
  end

  def number_to_currency(number)
    sprintf("$%2.2f", number)
  end

  def quote
    logger.debug "*** quote: 1 ***"
    risk_check!
    object = case self.errors.count > 0
    when true then { error: "We do not service this postcode at the moment." }
    when false
      logger.debug "*** quote: 2 ***"

      establishment_fee  = self.rental_bond * ESTABLISHMENT_FEE
      min_buy_back       = self.rental_bond - self.property_weekly_rent
      one_month_interest = min_buy_back * MONTHLY_INTEREST_RATE
      fixed_fee          = 150

      logger.debug "*** quote: 3 ***"

       object = {
          contract_type: self.contract_type,
          establishment_fee: number_to_currency(establishment_fee),
          weekly_rent:   number_to_currency(self.property_weekly_rent),
          fee:           number_to_currency(establishment_fee + self.property_weekly_rent),
        }


      case self.contract_type
      when TYPE[:new_rental_bond]
        logger.debug "*** quote: 4 ***"
        bond_buy_back = []
        1.upto(12) do |i|
          # case i
          # when 1, 2, 3 then bond_buy_back << min_buy_back
          # when 4..12   then bond_buy_back << min_buy_back + (i * one_month_interest)
          # end
          bond_buy_back << number_to_currency(min_buy_back + (i * one_month_interest))
        end

        object[:bond_buy_back] = bond_buy_back

      when TYPE[:existing_rental_bond]
        logger.debug "*** quote: 5 ***"

        now  = DateTime.now()
        days = (end_of_lease - now).to_i.days

        # object = case
        # when now > self.end_of_lease   then { error: "Your lease has expired"      }
        # when now > self.start_of_lease then { error: "Your lease has yet to begin" }
        # when days < 90                 then { error: "Your lease expires in less than 90 days" }
        # else
          # do some calculations here..

        #Formula for calculating how much we will pay for a given bond is as follows:
        # 1. If the bond is less than 3 months old. It is the bond_payout = total_bond - rent
        # 2. If the bond is between 4 - 6 months old it is: bond_payout = (bond - rent) + establishment_fee + one_month_interest
        # 3. If the bond is between 6 - 9 months it is:  bond_payout = ((bond - rent) + establishment_fee + one_month_interest) - ((months_left_on_lease/10)* establishment_fee)
          months_left_on_lease = (self.start_of_lease.year * 12 + self.start_of_lease.month) - (now.year * 12 + now.month)

          bond_payout   = nil
          bond_buy_back = []

          bond_payout = case months_left_on_lease
          when 9, 10, 11 then number_to_currency(self.rental_bond - self.property_weekly_rent)
          when 8, 7 then
            bond = self.rental_bond
            rent = self.property_weekly_rent
            bond_payout = (bond - rent) + establishment_fee + one_month_interest
          when 6, 5, 4 then
            bond = self.rental_bond
            rent = self.property_weekly_rent
            bond_payout = (bond - rent) + establishment_fee + one_month_interest - ((months_left_on_lease/10)* ESTABLISHMENT_FEE)
          else
            bond_payout = 0
          end

          object[:bond_payout] = bond_payout

        # end

      end
      logger.debug "*** quote: 6 ***"
      logger.debug object.inspect

      object
    end

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
