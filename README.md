Upgrade the system packages

```bash
sudo apt-get update && sudo apt-get install -fy && sudo apt-get upgrade -y
```

Set the system locale

```bash
locale -a # view availabe locales
sudo locale-gen en_US.UTF-8 # generate locale
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 # set locales
locale # view current locales
```

Configure the timezone and datetime

```bash
sudo apt-get install -y ntp # install network time protocol to get time from the internet
sudo service ntp start
sudo systemctl enable ntp # enable NTP service on boot up
sudo timedatectl set-timezone UTC
sudo hwclock -w # set the RTC time from the system time
sudo timedatectl set-ntp on && sudo service ntp restart # synchronize the time
timedatectl status # view local and RTC times
sudo service ntp status # view status of the NTP service
```

Install curl, git, vim, tmux, htop, openssl, zip, tar, net-tools

```bash
sudo apt-get install -y curl git vim tmux htop openssl zip unzip tar net-tools
```

Install and configure tmux

```bash
./tmux_init.sh && source ~/.bashrc
```

---

Install NodeJS

```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Install development tools for nodejs to build native addons

```bash
sudo apt-get install -y gcc g++ make
```

Install Yarn

```bash
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn
```

---

Install PHP v7.4

```bash
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install -y php7.4
```

Install PHP extensions

```bash
sudo apt-get install -y php7.4-dev php7.4-mbstring php7.4-ctype php7.4-bcmath php7.4-tokenizer php7.4-json php7.4-xml php7.4-xmlrpc php7.4-simplexml php7.4-dom php7.4-opcache php7.4-pdo php7.4-pdo-mysql php7.4-mysql php7.4-intl php7.4-curl php7.4-zip php7.4-xdebug php7.4-memcached php7.4-gettext php7.4-gd php7.4-imagick php7.4-iconv php7.4-fpm php7.4-sockets php7.4-xsl php7.4-soap
```

Configure PHP (CLI app)

```bash
sudo cp -f php.ini /etc/php/7.4/cli/php.ini
```

To locate the PHP command-line configuration, enter

```bash
php --ini | grep "Loaded Configuration File"
```

View installed PHP extensions

```bash
php -m # or 'php --ini'
```

Install Composer

```bash
php -r "copy('http://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
```

---

Install MySQL v8

```bash
wget -c https://repo.mysql.com//mysql-apt-config_0.8.13-1_all.deb &&\
sudo dpkg -i mysql-apt-config_0.8.13-1_all.deb # Enter OK

rm mysql-apt-config_0.8.13-1_all.deb &&\
sudo apt-get update &&\
sudo apt-get upgrade -y &&\
sudo apt-get install -y mysql-server mysql-client &&\
sudo apt-get autoremove -y
```

Configure MySQL server

```bash
sudo cp -f mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart
```

Secure the MySQL

```bash
sudo mysql_secure_installation
# Remove anonymous users?: y
# Disallow root login remotely?: y
# Remove test database and access to it?: y
# Reload privilege tables now?: y
```

Log into the MySQL server

```bash
sudo mysql -u root -h localhost -p # Enter root password
```

MySQL: Create user and grant permissions

```bash
mysql> CREATE USER 'nurassyl'@'localhost' IDENTIFIED BY '12345';
mysql> GRANT ALL PRIVILEGES ON * . * TO 'nurassyl'@'localhost';
mysql> FLUSH PRIVILEGES;
```

MySQL: Create database

```bash
mysql> CREATE DATABASE technodom_kz;
```

MySQL: Quit the MySQL shell

```bash
mysql> quit
```

View variables of the MySQL

```bash
sudo mysqladmin -h localhost -u root variables -p # Enter root password
```

---

Install Apache v2

```bash
sudo apt-get install -y apache2
sudo systemctl enable apache2
```

---

Install Apache modules

```bash
sudo apt-get install -y libapache2-mod-fcgid libapache2-mod-security2
```

Give permissions to the root folder of apache

```bash
sudo usermod -g www-data $USER
sudo chown -R :www-data /app/src/www/
sudo chmod 755 -R /app/src/www/
```

Configure Apache2

```bash
sudo cp -f apache2-conf/apache2.conf /etc/apache2/
sudo cp -f apache2-conf/000-default.conf /etc/apache2/sites-available/
sudo cp -f php.ini /etc/php/7.4/apache2/
sudo cp -f php.ini /etc/php/7.4/fpm/
sudo a2dismod php7.4
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.4-fpm
sudo a2enmod fcgid
sudo a2enmod rewrite
sudo a2enmod expires
sudo a2enmod headers
sudo a2enmod ssl
sudo a2enmod security2
sudo a2enmod log_debug # for development mode
sudo service php7.4-fpm restart
sudo systemctl restart apache2
```

View loaded modules

```bash
apachectl -M
```

Which MPM model Apache is running (event, worker, prefork)

```bash
apachectl -V | grep -i mpm # should return 'Server MPM: prefork'
```

---

Install ElasticSearch

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install -y elasticsearch
sudo /bin/systemctl enable elasticsearch.service

sudo cp -f elasticsearch.yml /etc/elasticsearch/
sudo /bin/systemctl stop elasticsearch.service && sudo /bin/systemctl start elasticsearch.service

# Secure installation
cd /usr/share/elasticsearch
sudo bin/elasticsearch-setup-passwords interactive # or 'auto' instead 'interactive'
curl -X GET http://localhost:9200 # or curl --user elastic -X GET http://localhost:9200
```

---

Create a swap space

```bash
# Show swap files
sudo swapon --show

# Remove swap file
sudo swapoff --all # or sudo swapoff -v /swapfile

# Create a swap file
sudo dd if=/dev/zero of=/swapfile bs=1k count=2048k && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile

# To keep swap file after reboot system add the following line '/swapfile none swap sw 0 0'
sudo vim /etc/fstab

# See stats of memory
sudo free -h
```

---

Install and configure app (https://devdocs.magento.com/guides/v2.4/install-gde/composer.html)

```bash
cd src/www/technodom_kz/
composer install

bin/magento setup:install --base-url=http://localhost:8080/technodom_kz --db-host=localhost --db-name=technodom_kz --db-user=nurassyl --db-password=12345 --admin-firstname=Nurasyl --admin-lastname=Aldan --admin-email=nurassyl.aldan@gmail.com --admin-user=nurassyl --admin-password=nurassyl12345 --language=ru_RU --currency=KZT --timezone=Asia/Almaty --use-rewrites=1 --search-engine=elasticsearch7 --elasticsearch-host=localhost --elasticsearch-port=9200 --elasticsearch-enable-auth=1 --elasticsearch-username=elastic --elasticsearch-password=123456
# After installation get admin URL.
```

---

View the MySQL all queries log (recommended in development mode)

```bash
sudo bash -c 'echo -e "[mysqld]\ngeneral_log = on\ngeneral_log_file=/tmp/mysql_quires.log" >> /etc/mysql/my.cnf'
sudo /etc/init.d/mysql restart
sudo tail -f /tmp/mysql_quires.log
```
