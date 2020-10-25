class IndexController < ApplicationController

  def index
  end

  def app
  end

  def privacy_policy
    @content = PrivacyPolicy::latest
  end

  def terms_and_conditions
    @content = TermsAndCondition::latest
  end

  def contact
    log_header

    @name    = params[:name]
    @email   = params[:email]
    @mobile  = params[:mobile]
    @message = params[:message]

    if !@name.nil?
      flash[:notice] = "Thank you. We sill respond to you as soon as we can."
    end

  end

end
