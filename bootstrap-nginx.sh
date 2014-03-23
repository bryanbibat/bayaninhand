ln -s /home/vagrant/.rubies ~/.rubies
source /usr/local/share/chruby/chruby.sh
chruby 1.9.3
gem install bundler passenger --no-ri --no-rdoc

cd /tmp
wget http://www.nginx.org/download/nginx-1.4.7.tar.gz
tar -xf nginx-1.4.7.tar.gz

passenger-install-nginx-module --prefix=/usr/local/nginx --nginx-source-dir=/tmp/nginx-1.4.7 --extra-configure-flags=none --languages=ruby --auto

wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
chmod +x /etc/init.d/nginx
update-rc.d -f nginx defaults

cp /vagrant/config/vagrant/nginx.conf /usr/local/nginx/conf/nginx.conf
service nginx start
