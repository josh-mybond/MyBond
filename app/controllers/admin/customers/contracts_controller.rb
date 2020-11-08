class Admin::Customers::ContractsController < Admin::BaseController
  before_action :log_header
  before_action :set_customer
  before_action :set_contract, only: [:show, :edit, :update, :destroy]

  # GET /contracts
  # GET /contracts.json
  def index
    @contracts = Contract
                   .where(customer_id: @customer.id)
                   .order(:created_at)
                   .page params[:page]

    respond_to do |format|
      format.html {}
      format.js   { render json: @contracts.to_json }
      format.json { render json: @contracts.to_json }
    end

  end

  # GET /contracts/1
  # GET /contracts/1.json
  def show
  end

  # GET /contracts/new
  def new
    @contract = Contract.new
    @contract.customer_id = @customer_id
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts
  # POST /contracts.json
  # def create
  #   @contract = contract.new(contract_params)
  #
  #   respond_to do |format|
  #     if @contract.save
  #       format.html { redirect_to admin_customer_contracts_path(@customer), notice: 'contract was successfully created.' }
  #       format.json { render :show, status: :created, location: @contract }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @contract.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /contracts/1
  # PATCH/PUT /contracts/1.json
  def update
    respond_to do |format|
      if @contract.update(contract_params)
        format.html { redirect_to admin_customer_contracts_path(@customer), notice: 'contract was successfully updated.' }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1
  # DELETE /contracts/1.json
  # def destroy
  #   @contract.destroy
  #   respond_to do |format|
  #     format.html { redirect_to admin_customer_contracts_path(@customer), notice: 'contract was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  def pay_by_credit_card
    @contract = Contract.find(params[:contract_id])

    case request.method.downcase
    when "get"  # Do nothing
    when "post"
      @contract.send_pay_by_credit_card_email!
      flash[:success] = "#{@customer.full_name} has been sent an email with a link to pay by credit card"
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:customer_id])
    end

    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contract_params
      params.fetch(:contract, {}).permit(:contract, :risk, :risk_limit)
    end
end
