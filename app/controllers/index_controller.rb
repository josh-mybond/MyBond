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

    @error = case
      when params[:name].blank?   then "Please provide your name"
      when params[:email].blank?  then "Please provide your email"
      when !valid_email?          then "Please provide a valid email"
      when params[:mobile].blank? then "Please provide a mobile number"
      when prams[:message].blank? then "Please provide a message"
      else nil
      end

    case @error.nil?
    when false then flash[:error] = @error
    when true
      # send email to... contact@mybond.com.au
      flash[:notice] = "Thank you. We will respond to you as soon as we can."
    end

  end

  private

  def email_valid?
    case params[:email] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    when nil then false
    when 0   then true
    end
  end

end
