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
- rbenv install 2.6.3
- rbenv global 2.6.3
- gem install bundler

* System dependencies

* Configuration

* Database creation

#### Install gems for postgres
- sudo apt-get install libpq-dev
- gem install pg -v 1.2.3

#### Postgres
- sudo apt install postgresql
- sudo -u postgres createuser -s mybond -P
- pathword
- psql -U mybond -h localhost postgres
- CREATE DATABASE mybond_production;
- GRANT ALL PRIVILEGES ON DATABASE mybond_production TO mybond;


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


  - Change ownership & permissions
sudo chmod -R ugo+rw /var/apps
sudo chown -R ubuntu:ubuntu /var/apps
    - Clone git repo
      - sudo git clone from repo
      - sudo chmod -R ug+rw repo_dir
      - mv repo_dir diamonddotz


* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
