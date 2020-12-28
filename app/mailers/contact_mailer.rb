class ContactMailer < ApplicationMailer
  default from: ENV['contact_email']


  def contact(to, message)
    @message = message

    # mail(from: "contact@mybond.com.au", to: to, subject: "Contact Notification") do |format|
    mail(to: to, subject: "Contact Notification") do |format|
      format.html { render "contact" }
      format.text { render plain: 'Unable to render.' }
    end
  end


end
