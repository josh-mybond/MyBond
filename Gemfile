source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.0.2'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# User model
gem 'devise'

# paging
gem 'kaminari'

# Redis
gem 'redis'
gem 'hiredis'  # hi-speed redis

# Chartkick & groupdate
gem "chartkick"
gem 'groupdate'

# Networking API
gem 'httparty'

# Countries & phone
gem 'countries', require: 'countries/global'
gem 'country_select', '~> 4.0'
gem 'phony'                         # translate international numbers into twilio whatsappp numbers
gem 'phonelib'                      # validates phone numbers

# Let's handle email professionally
gem 'truemail'

# Easy peasy transactions
gem 'stripe'

# HTML Editor
gem 'tinymce-rails'

# Colored logs
# gem 'rainbow'
gem 'colorize'

# Recaptcha
gem "recaptcha"

# Amazon File upload
gem "aws-sdk-s3", require: false
gem 'image_processing'

# amazon account id: 058371271856
# amazon user_name: mybond-master

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # open emails in browser (safari)
  gem "letter_opener"

  # Bullet - notify when db queries could be better!
  gem "bullet"
  gem "ruby-growl"
end

# 4c2df46de76fe9f7eb82507a3956b1f5

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.5'
# gem "font-awesome-rails"
