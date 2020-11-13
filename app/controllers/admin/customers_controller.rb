class Admin::CustomersController < Admin::BaseController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    log_header

    @customers = case params[:query].blank?
      when false
        Customer
          .where("email ILIKE ? ", "%#{params[:query]}%")
          .order(created_at: :desc)
          .page params[:page]
      when true
        Customer
          .order(created_at: :desc)
          .page params[:page]
      end

    respond_to do |format|
      format.html { }
      format.js   { render json: @customers.to_json }
      format.json { render json: @customers.to_json }
    end

  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @customer = Customer.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to admin_customers_url, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to admin_customers_url, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to admin_customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.fetch(:customer, {}).permit(:email, :first_name, :last_name, :iso_country_code, :mobile_number, :residential_status, :date_of_birth, :previous_address, :previous_agent)
    end
end
