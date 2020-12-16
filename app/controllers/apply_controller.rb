class ApplyController < ApplicationController

  layout 'apply'

  before_action :get_contract, only: [:success, :failure, :cancel]

  def how_to_apply
    log_header

    puts "---------------------------------"
    puts params[:contract]

    if params[:contract].nil?
      redirect_to root_path and return
    end

    @contract = Contract.new(contract_params)
    @quote    = @contract.quote
  end


  def step1
    log_header

    # CustomerMailer::application_update(Customer.last).deliver_now

    # @customer = Customer.find(params[:id]) if params[:id]
    # @customer = Customer.new if @customer.nil?

    @customer = params[:id].nil?          ? Customer.new : Customer.find(params[:id])
    @contract = params[:contract_id].nil? ? Contract.new(contract_params) : Contract.find(params[:contract_id])

    puts "-------------------------"
    puts @contract.inspect

    # Add some test data to speed up testing
    # Remove for production
    if Rails.env.development?
      session[:customer_id] = nil
      session[:contract_id] = nil

      if @customer.new_record?
        @customer.first_name = 'first'
        @customer.last_name  = 'last'
        @customer.email      = Customer::test_email
        @password            = 'test_password!@#$'
        @customer.mobile_number = "0432212713"
        @customer.date_of_birth = Date.parse("1968-12-15")
        @customer.previous_address = "over there"
        @customer.previous_agent   = "Previous Agent Bob"
      end
    end

  end

  def step2
    log_header

    @customer = Customer.find(session[:customer_id]) if session[:customer_id]
    @contract = Contract.find(session[:contract_id]) if session[:contract_id]

    case request.method.downcase
    when "get"  # back button has been pressed - do nothing

    when "post" # form submission

      # Ensure recaptcha has passed
      if Rails.env.production?
        if !verify_recaptcha(model: @customer)
          render :step1 and return
        end
      end

      case @customer.nil?
      when false then @customer.update(customer_params)
      when true
        # create device friendly customer
        # ignore password & confirmation email
        temp_password = Devise.friendly_token[0,20]

        customer  = customer_params
        customer[:password]              = temp_password
        customer[:password_confirmation] = temp_password
        customer[:confirmed_at]          = DateTime.now

        # @customer = Customer.create(customer)

        @customer = Customer.new(customer)
        session[:customer_id] = @customer.id if @customer.save
      end
    end

    if !@customer or !@customer.valid?
      @customer = Customer.new if !@customer
      render :step1 and return
    end

    @contract    = Contract.new if @contract.nil?
    @value_label = @contract.value_label

    # Add some test data to speed up testing
    if Rails.env.development?
      if @contract.new_record?
        @contract.agent_name      = "Test agent name"
        @contract.agent_telephone = "123456789"

        # TODO: validate agent_email
        @contract.agent_email       = "agent@test.com"
        @contract.property_address  = "17 Malvern Avenue, Manly, 2095, NSW"
        @contract.property_postcode = "2095"
        @contract.property_iso_country_code = "AU"

        @contract.property_weekly_rent = 1000
        @contract.rental_bond          = 4000
        @contract.rental_bond_board_id = "ID:12345678910"
      end
    end

  end

  #
  # Stripe
  #

  def step3
    log_header

    # Stripe
    # @customer = Customer.find(params[:customer_id]) if params[:customer_id] and !params[:customer_id].blank?
    # @contract = Contract.find(params[:contract_id]) if params[:contract_id] and !params[:contract_id].blank?
    #
    # case @contract.nil?
    # when false then @contract.update(contract_params)
    # when true
    #   params[:contract][:customer_id] = @customer.id
    #   @contract = Contract.create(contract_params)
    # end
    #
    # @contract.save
    # @contract.risk_check!
    #
    # if !@contract.valid?
    #   render :step2 and return
    # end
    #
    # @session = @contract.create_stripe_session!(@customer.email)
    # session[:contract_id] = @contract.id
    #
    # l "*** session[:contract_id] 1 ***"
    # l session[:contract_id]
  end

  def pay_by_credit_card
    log_header

    l "*** pay_by_credit_card: 1 ***"

    @contract = Contract.find_by(pay_by_credit_card_guid: params[:guid])

    case @contract.nil?
    when true then @error = "Unable to process your request"
    when false
      l "*** pay_by_credit_card: 2 ***"

      @customer = @contract.customer
      @error    = "Invalid request" if @customer.nil?
    end

    if @customer
      l "*** pay_by_credit_card: 3 ***"
      @session = @contract.create_stripe_session!(@customer.email)
      session[:contract_id] = @contract.id

      l "session[:contract_id]: #{session[:contract_id]}"
    end


    set_error
  end

  def payment_success
    log_header

    l "*** payment_success: 1"
    l session[:contract_id]

    handle_stripe_response
  end

  def payment_failed
    log_header

    handle_stripe_response
  end


  #
  # Split
  #

  def invitation
    log_header

    # l "invitation: 1"

    @customer = Customer.find(session[:customer_id]) if session[:customer_id]
    @contract = Contract.find(session[:contract_id]) if session[:contract_id]

    # l "invitation: 2"

    case request.method.downcase
    when "get"  # Refresh
      case
      when @customer.nil? then (redirect_to '/step1' and return)
      when @contract.nil? then (redirect_to '/step2' and return)
      end

    when "post" # form submission

      # l "invitation: 3"

      case @contract.nil?
      when false then @contract.update(contract_params)
      when true
        params[:contract][:customer_id] = @customer.id
        @contract = Contract.create(contract_params)
        @contract.save
      end
    end

    if !@contract or !@contract.valid?
      @contract = Customer.new if !@contract
      render :step2 and return
    end

    @contract.risk_check!

    if !@contract.valid?
      render :step2 and return
    end

    session[:contract_id] = @contract.id

    @agreement, @link = @contract.split_agreement_link(@customer)
  end

  def success
    log_header

    l "params[:agreement_ref]: #{params[:agreement_ref]}"

    @contract.split!
    render layout: 'apply_split_complete'
  end

  def failure
    @contract.split!
    render layout: 'apply_split_complete'
  end

  def cancel
    @contract.split!
    render layout: 'apply_split_complete'
  end

  private

  def handle_stripe_response
    l "*** handle_stripe_response: 1"
    l "session[:contract_id]: #{session[:contract_id]}"


    case session[:contract_id].nil?
    when true then @error = "Invalid session"
    when false
      @contract = Contract.find(session[:contract_id])

      l "*** handle_stripe_response: 1"
      l @contract.inspect

      case @contract.nil?
      when true  then @error = "Invalid contract"
      when false then @contract.update_from_stripe_session!
      end
    end

    set_error
  end

  def get_contract
    @contract = Contract.find(params[:contract_id])
  end
end
