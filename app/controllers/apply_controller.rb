class ApplyController < ApplicationController

  layout 'apply'

  def step1
    log_header

    @customer = Customer.find(params[:id]) if params[:id]
    @customer = Customer.new if @customer.nil?

    # Add some test data to speed up testing
    # Remove for production
    if Rails.env.development?
      @customer.first_name = 'first'
      @customer.last_name  = 'last'
      @customer.email      = Customer::test_email
      @password            = 'test_password!@#$'
    end

  end

  def step2
    log_header

    @customer = Customer.find(params[:customer_id]) if params[:customer_id] and !params[:customer_id].blank?
    @contract = Customer.find(params[:contract_id]) if params[:contract_id] and !params[:contract_id].blank?

    case @customer.nil?
    when false then @customer.update(customer_params)
    when true  then @customer = Customer.create(customer_params)
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
    # TODO: Remove for production
    @contract.value = 300000 if Rails.env.development?
    @contract.calculate_dates_and_amounts
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

    # recalculate payment
    @contract.calculate_dates_and_amounts
    @contract.save
  end

  private

  def customer_params
    params[:customer][:email] = Customer::test_email if Rails.env.development?
    params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def contract_params
    params.require(:contract).permit(:customer_id, :value)
  end

end
