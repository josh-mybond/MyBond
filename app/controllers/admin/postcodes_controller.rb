class Admin::PostcodesController < Admin::BaseController
  before_action :set_postcode, only: [:show, :edit, :update, :destroy]

  # GET /postcodes
  # GET /postcodes.json
  def index
    log_header

    Postcode.where("postcode ILIKE '2001'")

    @postcodes = case params[:query].blank?
      when false
        Postcode
          .where("postcode ILIKE ? ", "%#{params[:query]}%")
          .order(:created_at)
          .page params[:page]
      when true
        Postcode
          .order(:created_at)
          .page params[:page]
      end

    l @postcodes.inspect

    respond_to do |format|
      format.html {}
      format.js   { render json: @postcodes.to_json }
      format.json { render json: @postcodes.to_json }
    end

  end

  # GET /postcodes/1
  # GET /postcodes/1.json
  def show
  end

  # GET /postcodes/new
  def new
    @postcode = Postcode.new
  end

  # GET /postcodes/1/edit
  def edit
  end

  # POST /postcodes
  # POST /postcodes.json
  def create
    @postcode = Postcode.new(postcode_params)

    respond_to do |format|
      if @postcode.save
        format.html { redirect_to admin_postcodes_path, notice: 'postcode was successfully created.' }
        format.json { render :show, status: :created, location: @postcode }
      else
        format.html { render :new }
        format.json { render json: @postcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postcodes/1
  # PATCH/PUT /postcodes/1.json
  def update
    respond_to do |format|
      if @postcode.update(postcode_params)
        format.html { redirect_to admin_postcodes_path, notice: 'postcode was successfully updated.' }
        format.json { render :show, status: :ok, location: @postcode }
      else
        format.html { render :edit }
        format.json { render json: @postcode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postcodes/1
  # DELETE /postcodes/1.json
  def destroy
    @postcode.destroy
    respond_to do |format|
      format.html { redirect_to admin_postcodes_url, notice: 'postcode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_postcode
      @postcode = Postcode.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def postcode_params
      params.fetch(:postcode, {}).permit(:postcode, :risk, :risk_limit)
    end
end
