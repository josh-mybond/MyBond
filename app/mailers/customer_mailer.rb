class CustomerMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  default from: "contact@mybond.com.au"

  def application_update(customer)
    mail(from: "contact@mybond.com.au", to: email_with_name(customer), subject: "My Bond Application Update") do |format|
      format.html { render "application_update" }
      format.text { render plain: 'Unable to render.' }
    end
  end

  def paid
  end

  def cancelled_by_user
  end

  def pay_by_credit_card(contract)
    customer = contract.customer
    @url     = "#{ENV['who_am_i']}#{pay_by_credit_card_path(guid: contract.pay_by_credit_card_guid)}"

    mail(from: "contact@mybond.com.au", to: email_with_name(customer), subject: "My Bond - Credit Card Payment") do |format|
      format.html { render "pay_by_credit_card" }
      format.text { render plain: 'Unable to render.' }
    end
  end

  # def send_mail(template, subject, customer)
  # end

  private
    def email_with_name(customer)
      %("#{customer.full_name}" <#{customer.email}>)
    end


end
