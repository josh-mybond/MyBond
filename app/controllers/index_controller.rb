class IndexController < ApplicationController
  layout 'apply', except: :index

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
      # send email to... contact@mybond.com.au
      flash[:notice] = "Thank you. We will respond to you as soon as we can."
    end

  end

end
