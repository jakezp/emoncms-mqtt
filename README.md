# docker-emoncms

**Inactive repo: Rather https://github.com/jakezp/emoncms** Leaving this repo up as reference.

Emoncms is a powerful open-source web-app for processing, logging and visualizing energy, temperature and other environmental data. 
Emoncms with mqtt_input configured

Run with:

```
docker run -d --name='emoncms-mqtt' --net='bridge' \
          -e 'MYSQL_PASSWORD'='password' \
          -e 'MQTT_HOST'='host_ip' \
          -p '80:80/tcp' \
          -p '3306:3306/tcp' \
          -v '/tmp/etc/mysql':'/etc/mysql' \
          -v '/tmp/mysql':'/var/lib/mysql' \
          -v '/tmp/phpfiwa':'/var/lib/phpfiwa' \
          -v '/tmp/phpfina':'/var/lib/phpfina' \
          -v '/tmp/phptimeseries':'/var/lib/phptimeseries' \
          -v '/tmp/html':'/var/www/html' \
          -v '/tmp/crontabs':'/var/spool/cron/crontabs' \
          -v '/etc/localtime':'/etc/localtime':'ro' \
          jakezp/emoncms-mqtt
```
Change:
              MYSQL_PASSWORD - MySQL password
              MQTT_HOST - MQTT hostname or IP (If MQTT_HOST is not specified, MQTT support will not be enabled)
              /tmp - preferred location on the host
