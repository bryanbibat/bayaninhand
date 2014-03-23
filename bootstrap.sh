#!/usr/bin/env bash
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password password"
sudo apt-get update
sudo apt-get install -q -y build-essential libffi-dev libgdbm-dev libncurses5-dev libreadline-dev libssl-dev libyaml-dev zlib1g-dev mysql-server mysql-client libmysqlclient-dev sphinxsearch libxslt-dev libxml2-dev vim-tiny libcurl4-openssl-dev libpcre3-dev

sudo sed -i.bak 's/=no/=yes/' /etc/default/sphinxsearch

cd /tmp
wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
tar -xzvf chruby-0.3.8.tar.gz
cd chruby-0.3.8/
sudo make install

cd /tmp
wget -O ruby-install-0.4.1.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.1.tar.gz
tar -xzvf ruby-install-0.4.1.tar.gz
cd ruby-install-0.4.1/
sudo make install

ruby-install ruby 1.9.3

source /usr/local/share/chruby/chruby.sh

chruby 1.9.3

cp /vagrant/config/vagrant/* /vagrant/config/

cd /vagrant

gem install bundler --no-ri --no-rdoc --verbose

bundle --verbose --jobs 4

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake ts:rebuild
bundle exec rake db:test:prepare

cd ~
[ -f ~/.bash_profile ] || touch ~/.bash_profile
echo "source /usr/local/share/chruby/chruby.sh" > .bash_profile
echo "source /usr/local/share/chruby/auto.sh" >> .bash_profile
echo "chruby 1.9.3" >> .bash_profile
