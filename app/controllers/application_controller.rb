class ApplicationController < ActionController::Base
  include ApplicationHelper

  # protect_from_forgery with: :exception

  # layout :application

  def log_header
    l "------------------------------------------------------------------------------------------------------------------------------------------------"
    l "#{Time.now} ==== #{request.method} #{params[:controller]}##{params[:action]}:"
    l "#{Time.now} ==== #{request.method} #{params[:controller]}##{params[:action]}:"
    l params.inspect
    l "------------------------------------------------------------------------------------------------------------------------------------------------"
    l "------------------------------------------------------------------------------------------------------------------------------------------------"
  end

  def l(string)
    puts string
  end

  def set_error
    flash[:error] = @error if @error
  end

  def set_flash
    flash[:error] = @error if @error
  end

  def api_render(object)
    respond_to do |format|
      format.html { render plain: invalid_html_message }
      format.json { render json: object.to_json }
      format.js   { render json: object.to_json }
    end
  end

  def common_render(object, redirect_me = nil)
    respond_to do |format|
      format.html {
        set_flash
        redirect_to redirect_me if redirect_me
      }
      format.json { render json: object.to_json }
      format.js   { render json: object.to_json }
    end
  end

  #
  # Params
  #

  def customer_params
    params[:customer][:email] = Customer::test_email if Rails.env.development?
    params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation, :iso_country_code, :mobile_number, :date_of_birth, :residential_status, :previous_address, :previous_agent, :drivers_license, :face_photo)
  end

  def contract_params
    params.require(:contract).permit(:customer_id, :value, :agent_name, :agent_telephone, :agent_email, :property_weekly_rent, :property_address, :property_postcode, :property_country, :property_iso_country_code, :rental_bond, :rental_bond_board_id, :start_date, :end_date, :contract_type, :status, :rental_bond, :start_of_lease, :end_of_lease, :rolling_lease)
  end



  protected

  # # redirect user after login
  # def after_sign_in_path_for(resource)
  #   stored_location_for(resource) || current_user.admin? ? admin_root_path : root_path
  # end

  def after_sign_in_path_for(resource)
    case current_user.admin?
    when false then (stored_location_for(resource) || dashboard_path)
    when true  then admin_root_path
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :first_name, :last_name, :registration_code, :country_code, :postal_code, :password, :password_confirmation])
  end



end
