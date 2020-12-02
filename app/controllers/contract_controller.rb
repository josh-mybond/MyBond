class ContractController < ApplicationController
  layout 'apply'


  def calculator
  end

  def calculator_calculate
    log_header

    contract = Contract.new(contract_params)
    object   = contract.calculate_new_bond

    api_render object
  end

  private

  def contract_params
    params.require(:contract).permit(:customer_id, :value, :agent_name, :agent_telephone, :agent_email, :property_weekly_rent, :property_address, :property_postcode, :property_country, :property_iso_country_code, :rental_bond, :rental_bond_board_id, :start_date, :end_date, :contract_type, :status, :rental_bond, :start_of_lease, :end_of_lease, :rolling_lease)
  end

end
