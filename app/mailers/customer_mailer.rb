class CustomerMailer < ApplicationMailer
  default from: "contact@mybond.com.au"

  def application_update(customer)
    email_with_name = %("#{customer.full_name}" <#{customer.email}>)
    mail(from: "contact@mybond.com.au", to: email_with_name, subject: "My Bond Application Update") do |format|
      format.html { render "application_update" }
      format.text { render plain: 'Unable to render.' }
    end
  end

  def paid
  end

  def cancelled_by_user
  end


  def send_mail(template, subject, customer)
  end

end
