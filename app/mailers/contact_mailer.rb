class ContactMailer < ApplicationMailer
  default from: "hello@mybond.com.au"


  def contact(to, message)
    @message = message

    # mail(from: "contact@mybond.com.au", to: to, subject: "Contact Notification") do |format|
    mail(to: to, subject: "Contact Notification") do |format|
      format.html { render "contact" }
      format.text { render plain: 'Unable to render.' }
    end
  end


end
