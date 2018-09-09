# Dockerfile for base image for emoncms
FROM ubuntu:14.04

MAINTAINER zoemdoef

ENV DEBIAN_FRONTEND noninteractive

# Add mosquitto repo
ADD mosquitto-repo.gpg.key /mosquitto-repo.gpg.key
RUN apt-key add mosquitto-repo.gpg.key
RUN rm /mosquitto-repo.gpg.key
ADD mosquitto-jessie.list /etc/apt/sources.list.d/mosquitto-jessie.list

# Install packages
RUN apt-get update
RUN apt-get -yq install supervisor apache2 mysql-server mysql-client php5 libapache2-mod-php5 php5-mysql php5-curl php-pear \
    php5-dev php5-mcrypt php5-json git-core redis-server build-essential ufw ntp pwgen libmosquitto-dev

# Install pecl dependencies
RUN pear channel-discover pear.swiftmailer.org
# RUN pear channel-discover pear.apache.org/log4php
# RUN pear install log4php/Apache_log4php
RUN pecl install channel://pecl.php.net/dio-0.0.6 redis swift/swift
RUN printf "\n" | pecl install Mosquitto-alpha

# Add pecl modules to php5 configuration
RUN sh -c 'echo "extension=dio.so" > /etc/php5/apache2/conf.d/20-dio.ini'
RUN sh -c 'echo "extension=dio.so" > /etc/php5/cli/conf.d/20-dio.ini'
RUN sh -c 'echo "extension=redis.so" > /etc/php5/apache2/conf.d/20-redis.ini'
RUN sh -c 'echo "extension=redis.so" > /etc/php5/cli/conf.d/20-redis.ini'
RUN sh -c 'echo "extension=mosquitto.so" > /etc/php5/mods-available/mosquitto.ini'
RUN sh -c 'echo "extension=mosquitto.so" >> /etc/php5/apache2/php.ini'
RUN php5enmod mosquitto

# Enable modrewrite for Apache2
RUN a2enmod rewrite

# AllowOverride for / and /var/www
RUN sed -i '/<Directory \/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Set a server name for Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add db setup script
ADD run.sh /run.sh
ADD db.sh /db.sh
RUN chmod 755 /*.sh

# MySQL config
ADD my.cnf /root/my.cnf

# Add cron for emailreport
ADD crontab /root/crontab

# Add supervisord configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create required data repositories for emoncms feed engine
RUN mkdir /var/lib/phpfiwa
RUN mkdir /var/lib/phpfina
RUN mkdir /var/lib/phptimeseries
RUN mkdir /var/lib/timestore

# Create log directories & files
RUN mkdir /var/log/emoncms
RUN touch /var/log/emoncms.log
RUN touch /var/log/service-runner.log
RUN touch /var/log/cron.log
RUN chmod 666 /var/log/emoncms.log
RUN chmod 666 /var/log/service-runner.log
RUN chmod 666 /var/log/cron.log

# Expose them as volumes for mounting by host
VOLUME ["/etc/mysql", "/var/lib/mysql", "/var/lib/phpfiwa", "/var/lib/phpfina", "/var/lib/phptimeseries", "/var/www/html", "/var/spool/cron/crontabs/"]

EXPOSE 80 3306

WORKDIR /home/pi
CMD ["/run.sh"]
