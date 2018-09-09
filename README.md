# docker-emoncms

Emoncms is a powerful open-source web-app for processing, logging and visualizing energy, temperature and other environmental data. 
Emoncms with mqtt_input configured

Run with:

```
docker run -d --name='emoncms-mqtt' --net='bridge' \
          -e PUID=<UID> -e PGID=<GID> \
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
          zoemdoef/emoncms-mqtt
```
Change:
              MYSQL_PASSWORD - MySQL password
              MQTT_HOST - MQTT hostname or IP (If MQTT_HOST is not specified, MQTT support will not be enabled)
              /tmp - preferred location on the host
              
              User / Group Identifiers
Sometimes when using volumes (-v flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user PUID and group PGID.

Ensure any volume directories on the host are owned by the same user you specify and it will "just work" ™.

In this instance PUID=1001 and PGID=1001, to find yours use id user as below:

  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
