class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :set_title
  before_action :configure_permitted_parameters, if: :devise_controller?

  #
  # Logging
  #

  def log_header
    l "------------------------------------------------------------------------------------------------------------------------------------------------"
    l "#{Time.now} ==== #{request.method} #{params[:controller]}##{params[:action]}:"
    l "#{Time.now} ==== #{request.method} #{params[:controller]}##{params[:action]}:"
    l "request.remote_ip: #{request.remote_ip} : request.env['HTTP_X_FORWARDED_FOR']: #{request.env['HTTP_X_FORWARDED_FOR']}"
    l params.inspect
    # l "------------------------------------------------------------------------------------------------------------------------------------------------"
    # l "------------------------------------------------------------------------------------------------------------------------------------------------"
  end

  def l(string)
    puts string
  end

  #
  # Error handling
  #

  def set_error
    flash[:error] = @error if @error
  end

  def set_flash
    flash[:error] = @error if @error
  end

  #
  # Sanitize params
  #

  def customer_params
    params[:customer][:email] = Customer::test_email if Rails.env.development?
    params.require(:customer).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :iso_country_code,
      :mobile_number,
      :date_of_birth,
      :residential_status,
      :previous_address,
      :previous_agent,
      :drivers_license,
      :selfie,
      :previous_address_address1,
      :previous_address_address2,
      :previous_address_city,
      :previous_address_state,
      :previous_address_postcode,
      :previous_address_country_code
    )
  end

  def contract_params
    params.require(:contract).permit(
      :customer_id,
      :value,
      :agent_name,
      :agent_telephone,
      :agent_email,
      :property_weekly_rent,
      :property_address,
      :property_postcode,
      :property_country,
      :property_iso_country_code,
      :rental_bond_board_id,
      :start_date,
      :end_date,
      :contract_type,
      :status,
      :rental_bond,
      :start_of_lease,
      :end_of_lease,
      :rolling_lease,
      :customer_id,
      :data,
      :status,
      :property_address_address1,
      :property_address_address2,
      :property_address_city,
      :property_address_state,
      :property_address_postcode,
      :property_address_country_code
    )
  end

  #
  # Request Method
  #

  def method
    request.method.downcase
  end

  def get?
    method == "get"
  end

  def post?
    method == "post"
  end

  def patch?
    method == "patch"
  end

  def delete?
    method == "delete"
  end



  protected

    def after_sign_in_path_for(resource)
      case current_user.admin?
      when false then (stored_location_for(resource) || dashboard_path)
      when true  then admin_root_path
      end
    end

    #
    # Before filters
    #

    def set_title
      @title = "MyBond"

      case params[:controller]
      when "apply" then @title += " - #{params[:action].gsub("_", " ")}"
      when "index" then @title += " - #{params[:action].gsub("_", " ")}"
      end

      @title += " - Access your Rental Bond today!"
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
    end
end
