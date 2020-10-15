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
    logger.debug string
  end

  # redirect user after login
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || current_user.admin? ? admin_root_path : root_path
  end

end
