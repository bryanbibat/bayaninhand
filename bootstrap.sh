#!/usr/bin/env bash
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password password"
sudo apt-get update
sudo apt-get install -q -y build-essential libffi-dev libgdbm-dev libncurses5-dev libreadline-dev libssl-dev libyaml-dev zlib1g-dev mysql-server mysql-client libmysqlclient-dev sphinxsearch libxslt-dev libxml2-dev vim-tiny libcurl4-openssl-dev libpcre3-dev curl python-software-properties
sudo sed -i.bak 's/=no/=yes/' /etc/default/sphinxsearch

sudo add-apt-repository ppa:brightbox/ruby-ng-experimental -y
sudo apt-get update

sudo apt-get install -y ruby2.1 ruby2.1-dev 
sudo gem2.1 install bundler --no-ri --no-rdoc --verbose

cp /vagrant/config/vagrant/* /vagrant/config/

cd /vagrant

bundle --binstubs --path=/home/vagrant/tmp/bundle --verbose --jobs 2

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake ts:rebuild
bundle exec rake db:test:prepare
