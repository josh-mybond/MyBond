class Admin::PrivacyPoliciesController < Admin::BaseController
  before_action :set_privacy_policy, only: [:show, :edit, :update, :destroy]

  # GET /privacy_policies
  # GET /privacy_policies.json
  def index
    log_header

    @privacy_policies = case params[:query].blank?
      when false
        PrivacyPolicy
          .where("privacy_policies ILIKE ? ", "%#{params[:query]}%")
          .order(:created_at)
          .page params[:page]
      when true
        PrivacyPolicy
          .order(created_at: :desc)
          .page params[:page]
      end

    respond_to do |format|
      format.html {}
      format.js   { render json: @privacy_policies.to_json }
      format.json { render json: @privacy_policies.to_json }
    end

  end

  # GET /privacy_policies/1
  # GET /privacy_policies/1.json
  def show
  end

  # GET /privacy_policies/new
  def new
    @privacy_policy = PrivacyPolicy.new
  end

  # GET /privacy_policies/1/edit
  def edit

  end

  # POST /privacy_policies
  # POST /privacy_policies.json
  def create
    @privacy_policy = PrivacyPolicy.new(privacy_policies_params)

    respond_to do |format|
      if @privacy_policy.save
        format.html { redirect_to admin_privacy_policies_path, notice: 'Privacy Policy was succesfully created.' }
        format.json { render :show, status: :created, location: @privacy_policy }
      else
        format.html { render :new }
        format.json { render json: @privacy_policy.errors, status: :unprocesable_entity }
      end
    end
  end

  # PATCH/PUT /privacy_policies/1
  # PATCH/PUT /privacy_policies/1.json
  def update
    respond_to do |format|
      if @privacy_policy.update(privacy_policies_params)
        format.html { redirect_to admin_privacy_policies_path, notice: 'Privacy Policy was succesfully updated.' }
        format.json { render :show, status: :ok, location: @privacy_policy }
      else
        format.html { render :edit }
        format.json { render json: @privacy_policy.errors, status: :unprocesable_entity }
      end
    end
  end

  # DELETE /privacy_policies/1
  # DELETE /privacy_policies/1.json
  def destroy
    @privacy_policy.destroy
    respond_to do |format|
      format.html { redirect_to admin_privacy_policies_url, notice: 'privacy_policies was succesfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_privacy_policy
    @privacy_policy = PrivacyPolicy.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def privacy_policies_params
    params.fetch(:privacy_policy, {}).permit(:privacy_policy, :status, :summary, :full, :version)
  end

end
