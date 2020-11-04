class Admin::ContactsController < Admin::BaseController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    log_header

    @contacts = case params[:query].blank?
      when false
        Contact
          .where("contact ILIKE ? ", "%#{params[:query]}%")
          .order(:created_at)
          .page params[:page]
      when true
        Contact
          .order(:created_at)
          .page params[:page]
      end

    respond_to do |format|
      format.html {}
      format.js   { render json: @contacts.to_json }
      format.json { render json: @contacts.to_json }
    end

  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to admin_contacts_path, notice: 'contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to admin_contacts_path, notice: 'contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to admin_contacts_url, notice: 'contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = contact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_params
      params.fetch(:contact, {}).permit(:contact, :risk, :risk_limit)
    end
end
