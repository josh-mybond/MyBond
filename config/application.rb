require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fundmybond
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.time_zone = "Sydney"
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL',
      'Access-Control-Allow-Origin' => '*'
    }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Load local environment variables
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end


    # Allow access to api from other domains
    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins  '*'
    #     resource '*', headers: :any, methods: [:get, :post, :options]
    #   end
    # end

    # Listen to websocket requests on /websocket
    config.action_cable.mount_path = '/websocket'

    # Handle tinymce
    config.tinymce.install = :compile
  end
end
