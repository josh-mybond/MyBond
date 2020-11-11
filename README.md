# README

This README would normally document whatever steps are necessary to get the
application up and running.

##
- Create linux Ubuntu instance with ssh
- ssh to to host
- sudo apt update

#### Install GCC
- sudo apt install -y build-essential checkinstall zlib1g-dev libssl-dev libreadline-dev
- sudo apt-get install gcc g++ make
- sudo apt-get install manpages-dev
- gcc --version

Things you may want to cover:

* Ruby version
#### Install rbenv
- cd ~
- git clone https://github.com/rbenv/rbenv.git ~/.rbenv
- echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
- echo 'eval "$(rbenv init -)"' >> ~/.bashrc
- exec $SHELL
- git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
- rbenv install 2.6.6
- rbenv global 2.6.6
- gem install bundler

* System dependencies

* Configuration

* Database creation

#### Install gems for postgres
- sudo apt-get install libpq-dev
- gem install pg -v 1.2.3

mybond_development / pathword

#### Postgres
- sudo apt install postgresql

##### Production
- sudo -u postgres createuser -s mybond -P
- pathword
- psql -U mybond -h localhost postgres
- CREATE DATABASE mybond_production;
- GRANT ALL PRIVILEGES ON DATABASE mybond_production TO mybond;

##### Development/Staging
- sudo -u postgres createuser -s mybond_development -P
- pathword
- psql -U mybond_development -h localhost postgres
- CREATE DATABASE mybond_development;
- GRANT ALL PRIVILEGES ON DATABASE mybond_development TO mybond_development;


#### Install App Dir
cd /var/
  - sudo mkdir apps
  - cd /var/apps
  - sudo mkdir /var/apps/shared
sudo mkdir /var/apps/shared/production-mybond
sudo mkdir /var/apps/shared/production-mybond/config
sudo mkdir /var/apps/shared/production-mybond/log
sudo mkdir /var/apps/shared/production-mybond/sockets
sudo mkdir /var/apps/shared/production-mybond/tmp
sudo mkdir /var/apps/shared/production-mybond/tmp/pids
sudo mkdir /var/apps/shared/development-mybond
sudo mkdir /var/apps/shared/development-mybond/config
sudo mkdir /var/apps/shared/development-mybond/log
sudo mkdir /var/apps/shared/development-mybond/sockets
sudo mkdir /var/apps/shared/development-mybond/tmp
sudo mkdir /var/apps/shared/development-mybond/tmp/pids
sudo mkdir /var/apps/shared/staging-mybond
sudo mkdir /var/apps/shared/staging-mybond/config
sudo mkdir /var/apps/shared/staging-mybond/log
sudo mkdir /var/apps/shared/staging-mybond/sockets
sudo mkdir /var/apps/shared/staging-mybond/tmp
sudo mkdir /var/apps/shared/staging-mybond/tmp/pids


  - Change ownership & permissions
sudo chmod -R ugo+rw /var/apps
sudo chown -R ubuntu:ubuntu /var/apps
    - Clone git repo
      - sudo git clone from repo
      - sudo chmod -R ug+rw repo_dir
      - mv repo_dir diamonddotz

# Install Nginx
- sudo apt-get install nginx

# Install Redis
- sudo apt update
- sudo apt install redis-server
- sudo vim /etc/redis/redis.conf
- sudo service redis start


#### Create Puma config

- /var/apps/shared/staging-mybond/config/puma.rb

# Change to match your CPU core count
workers 1

# Min and Max threads per worker
#threads 1, 6

app_dir = "/var/apps/staging-mybond"
shared_dir = "/var/apps/shared/staging-mybond"

# Default to production
rails_env = "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

#### Linux Service
- /etc/systemd/system/staging-mybond.service

[Unit]
Description=My Bond Staging - Puma Rails Server
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/var/apps/staging-mybond
ExecStart=/home/ubuntu/.rbenv/bin/rbenv exec bundle exec puma -C /var/apps/shared/staging-mybond/config/puma.rb
ExecStop=/home/ubuntu/.rbenv/bin/rbenv exec bundle exec pumactl -S /var/apps/shared/staging-mybond/tmp/pids/puma.state stop
TimeoutSec=15
Restart=always

[Install]
WantedBy=multi-user.target


#### Nginx Config

# /etc/nginx/sites-enabled/staging.mybond.com.au

upstream stagingmybond {
    # Path to Puma SOCK file, as defined previously
    server unix:/var/apps/shared/staging-mybond/sockets/puma.sock fail_timeout=0;
}

server {
    server_name staging.mybond.com.au;
    listen 80;

    root /var/apps/staging-mybond/public;

    try_files $uri/index.html $uri @stagingmybond;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location @stagingmybond {
	      proxy_http_version 1.1;

	      proxy_set_header Upgrade $http_upgrade;
	      proxy_set_header Connection "upgrade";

        proxy_pass http://stagingmybond;
        # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        # proxy_set_header Host $http_host;
        #proxy_redirect off;

        proxy_set_header  Host $host;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-Proto $scheme;
        proxy_set_header  X-Forwarded-Ssl on; # Optional
        proxy_set_header  X-Forwarded-Port $server_port;
        proxy_set_header  X-Forwarded-Host $host;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}



* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
