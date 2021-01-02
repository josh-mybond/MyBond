class Admin::ChartsController < Admin::BaseController
  before_action :authenticate_user!

  def signups
    render json: Customer.group_by_day(:created_at).count
  end

end
