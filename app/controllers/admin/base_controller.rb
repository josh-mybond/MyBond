class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  layout 'admin'

  def check_admin
    case
    when !current_user        then redirect_to root_path
    when !current_user.admin? then redirect_to root_path
    end
  end

end
