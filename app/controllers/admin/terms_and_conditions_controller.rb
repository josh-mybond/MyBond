class Admin::TermsAndConditionsController < Admin::BaseController
  before_action :set_terms_and_condition, only: [:show, :edit, :update, :destroy]

  # GET /terms_and_conditions
  # GET /terms_and_conditions.json
  def index
    log_header

    @terms_and_conditions = case params[:query].blank?
      when false
        TermsAndCondition
          .where("terms_and_conditions ILIKE ? ", "%#{params[:query]}%")
          .order(:created_at)
          .page params[:page]
      when true
        TermsAndCondition
          .order(created_at: :desc)
          .page params[:page]
      end

    respond_to do |format|
      format.html {}
      format.js   { render json: @terms_and_conditions.to_json }
      format.json { render json: @terms_and_conditions.to_json }
    end

  end

  # GET /terms_and_conditions/1
  # GET /terms_and_conditions/1.json
  def show
  end

  # GET /terms_and_conditions/new
  def new
    @terms_and_condition = TermsAndCondition.new
  end

  # GET /terms_and_conditions/1/edit
  def edit

  end

  # POST /terms_and_conditions
  # POST /terms_and_conditions.json
  def create
    @terms_and_condition = TermsAndCondition.new(terms_and_conditions_params)

    respond_to do |format|
      if @terms_and_condition.save
        format.html { redirect_to admin_terms_and_conditions_path, notice: 'terms_and_condition was succesfully created.' }
        format.json { render :show, status: :created, location: @terms_and_condition }
      else
        format.html { render :new }
        format.json { render json: @terms_and_condition.errors, status: :unprocesable_entity }
      end
    end
  end

  # PATCH/PUT /terms_and_conditions/1
  # PATCH/PUT /terms_and_conditions/1.json
  def update
    respond_to do |format|
      if @terms_and_condition.update(terms_and_conditions_params)
        format.html { redirect_to admin_terms_and_conditions_path, notice: 'terms_and_condition was succesfully updated.' }
        format.json { render :show, status: :ok, location: @terms_and_condition }
      else
        format.html { render :edit }
        format.json { render json: @terms_and_condition.errors, status: :unprocesable_entity }
      end
    end
  end

  # DELETE /terms_and_conditions/1
  # DELETE /terms_and_conditions/1.json
  def destroy
    @terms_and_condition.destroy
    respond_to do |format|
      format.html { redirect_to admin_terms_and_conditions_url, notice: 'terms_and_conditions was succesfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_terms_and_condition
    @terms_and_condition = TermsAndCondition.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def terms_and_conditions_params
    params.fetch(:terms_and_condition, {}).permit(:terms_and_condition, :status, :summary, :full, :version)
  end

end
