
class MLEmailValidator

  def self.valid?(email)
    email =~ URI::MailTo::EMAIL_REGEXP
  end

end
