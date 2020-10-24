class ApplyController < ApplicationController

  layout 'apply'

  def step1
    log_header

    @customer = Customer.find(params[:id]) if params[:id]
    @customer = Customer.new if @customer.nil?

    # Add some test data to speed up testing
    # Remove for production
    if Rails.env.development?
      if @customer.new_record?
        @customer.first_name = 'first'
        @customer.last_name  = 'last'
        @customer.email      = Customer::test_email
        @password            = 'test_password!@#$'
        @customer.mobile_number = "0432212713"
      end
    end

  end

  def step2
    log_header

    @customer = Customer.find(params[:customer_id]) if params[:customer_id] and !params[:customer_id].blank?
    @contract = Customer.find(params[:contract_id]) if params[:contract_id] and !params[:contract_id].blank?

    case @customer.nil?
    when false then @customer.update(customer_params)
    when true  then

      # create device friendly customer
      # ignore password & confirmation email
      temp_password = Devise.friendly_token[0,20]

      customer  = customer_params
      customer[:password]              = temp_password
      customer[:password_confirmation] = temp_password
      customer[:confirmed_at]          = DateTime.now

      @customer = Customer.create(customer)
    end

    if !@customer.valid?
      render :step1 and return
    end

    case @contract.nil?
    when false then @contract.update(contract_params)
    when true  then @contract = Contract.new
    end

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

  def step3
    log_header

    @customer = Customer.find(params[:customer_id]) if params[:customer_id] and !params[:customer_id].blank?
    @contract = Customer.find(params[:contract_id]) if params[:contract_id] and !params[:contract_id].blank?

    case @contract.nil?
    when false then @contract.update(contract_params)
    when true
      params[:contract][:customer_id] = @customer.id
      @contract = Contract.create(contract_params)
    end

    @contract.save
    @contract.risk_check!

    if !@contract.valid?
      render :step2 and return
    end

    @session = @contract.create_stripe_session!(@customer.email)
    session[:contract_id] = @contract.id

    l "*** session[:contract_id] 1 ***"
    l session[:contract_id]
  end

  def step4
  end

  def payment_success
    log_header

    l "*** session[:contract_id] 2 ***"
    l session[:contract_id]

    handle_stripe_response
  end

  def payment_failed
    log_header

    handle_stripe_response
  end

  private

  def handle_stripe_response
    case session[:contract_id].nil?
    when true then @error = "Invalid session"
    when false
      @contract = Contract.find(session[:contract_id])

      case @contract.nil?
      when true  then @error = "Invalid contract"
      when false then @contract.update_from_stripe_session!
      end
    end

  end

  def customer_params
    params[:customer][:email] = Customer::test_email if Rails.env.development?
    params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation, :iso_country_code, :mobile_number)
  end

  def contract_params
    params.require(:contract).permit(:customer_id, :value, :agent_name, :agent_telephone, :agent_email, :property_weekly_rent, :property_address, :property_postcode, :property_country, :property_iso_country_code, :rental_bond, :rental_bond_board_id)
  end

end
