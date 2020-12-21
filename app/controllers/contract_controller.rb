class ContractController < ApplicationController
  layout 'calculator'


  def calculator
    log_header
    
  end

  def calculator_calculate
    log_header

    contract = Contract.new(contract_params)
    api_render contract.quote
  end


end
