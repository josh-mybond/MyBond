# https://github.com/ambethia/recaptcha#alternative-api-key-setup
Recaptcha.configure do |config|
  config.site_key   = ENV['RECAPTCHA_SITE_KEY']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
end
