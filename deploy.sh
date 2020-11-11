#!/bin/bash
# Need to compile on Free Amazon EC2
export NODE_OPTIONS="--max-old-space-size=350"
git pull
bundle install --without development test
yarn install
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production NODE_ENV=production RACK_ENV=production bundle exec rake assets:clobber
RAILS_ENV=production NODE_ENV=production RACK_ENV=production nice bundle exec rails assets:precompile
sudo service staging-mybond restart
