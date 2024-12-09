# Partie 1 : service SSH
## I. Service SSH

### 1. Analyse du service
🌞 S'assurer que le service sshd est démarré
```sh
[nathan@web ~]$ sudo systemctl status sshd
[sudo] password for nathan:
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Sun 2024-12-01 17:08:21 CET; 9min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 704 (sshd)
      Tasks: 1 (limit: 11083)
     Memory: 4.9M
        CPU: 128ms
     CGroup: /system.slice/sshd.service
             └─704 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Dec 01 17:08:20 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
Dec 01 17:08:21 localhost.localdomain sshd[704]: Server listening on 0.0.0.0 port 22.
Dec 01 17:08:21 localhost.localdomain sshd[704]: Server listening on :: port 22.
Dec 01 17:08:21 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
Dec 01 17:17:34 web.tp1.b1 sshd[1331]: Accepted password for nathan from 10.1.1.100 port 57996 ssh2
Dec 01 17:17:34 web.tp1.b1 sshd[1331]: pam_unix(sshd:session): session opened for user nathan(uid=1000) by nathan(uid=0)
```

🌞 Analyser les processus liés au service SSH
```sh
[nathan@web ~]$ ps -aux | grep sshd
root         704  0.0  0.5  16796  9344 ?        Ss   17:08   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1331  0.0  0.6  20156 11520 ?        Ss   17:17   0:00 sshd: nathan [priv]
nathan      1335  0.0  0.3  20352  7096 ?        S    17:17   0:00 sshd: nathan@pts/0
nathan      1441  0.0  0.1   6408  2432 pts/0    S+   19:22   0:00 grep --color=auto sshd
[nathan@web ~]$ sudo ss lnpt | grep sshd
```

🌞 Déterminer le port sur lequel écoute le service SSH
```sh
[nathan@web ~]$ sudo ss -alnpt | grep sshd
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=704,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=704,fd=4))
```

🌞 Consulter les logs du service SSH
```sh
[nathan@web ~]$ sudo journalctl -xe -u sshd
[sudo] password for nathan:
~
~
~
~
~
~
~
Dec 01 17:08:20 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 223.
Dec 01 17:08:21 localhost.localdomain sshd[704]: Server listening on 0.0.0.0 port 22.
Dec 01 17:08:21 localhost.localdomain sshd[704]: Server listening on :: port 22.
Dec 01 17:08:21 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 223.
Dec 01 17:17:34 web.tp1.b1 sshd[1331]: Accepted password for nathan from 10.1.1.100 port 57996 ssh2
Dec 01 17:17:34 web.tp1.b1 sshd[1331]: pam_unix(sshd:session): session opened for user nathan(uid=1000) by nathan(uid=0)
Dec 01 19:25:38 web.tp1.b1 sshd[1460]: Accepted password for nathan from 10.1.1.100 port 60706 ssh2
Dec 01 19:25:38 web.tp1.b1 sshd[1460]: pam_unix(sshd:session): session opened for user nathan(uid=1000) by nathan(uid=0)
```
```sh
[nathan@web ~]$ sudo tail /var/log/secure
Dec  1 19:25:38 vbox sshd[1460]: pam_unix(sshd:session): session opened for user nathan(uid=1000) by nathan(uid=0)
Dec  1 19:27:22 vbox sudo[1493]:  nathan : TTY=pts/1 ; PWD=/home/nathan ; USER=root ; COMMAND=/bin/journalctl -xe -u sshd
Dec  1 19:27:22 vbox sudo[1493]: pam_unix(sudo:session): session opened for user root(uid=0) by nathan(uid=1000)
Dec  1 19:27:22 vbox sudo[1493]: pam_unix(sudo:session): session closed for user root
Dec  1 19:29:35 vbox sudo[1501]:  nathan : TTY=pts/0 ; PWD=/home/nathan ; USER=root ; COMMAND=/bin/cat /var/log/auth.log
Dec  1 19:29:35 vbox sudo[1501]: pam_unix(sudo:session): session opened for user root(uid=0) by nathan(uid=1000)
Dec  1 19:29:35 vbox sudo[1501]: pam_unix(sudo:session): session closed for user root
Dec  1 19:31:21 vbox sudo[1508]:  nathan : TTY=pts/0 ; PWD=/home/nathan ; USER=root ; COMMAND=/bin/tail /var/log/auth.log
Dec  1 19:31:21 vbox sudo[1508]: pam_unix(sudo:session): session opened for user root(uid=0) by nathan(uid=1000)
Dec  1 19:31:21 vbox sudo[1508]: pam_unix(sudo:session): session closed for user root
```

### 2. Modification du service

🌞 Identifier le fichier de configuration du serveur SSH
```sh
[nathan@web ~]$ ls /etc/ssh | grep sshd
sshd_config
sshd_config.d
```

🌞 Modifier le fichier de conf
```sh
[nathan@web ~]$ echo $RANDOM
8709
```
* Port d'écoute
```sh
[nathan@web ~]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 8709
#GatewayPorts no
```
* Firewall
  ```sh
  [nathan@web ~]$ sudo firewall-cmd --permanent --remove-port=22/tcp
  success
  [nathan@web ~]$ sudo firewall-cmd --permanent --add-port=8709/tcp
  success
  [nathan@web ~]$ sudo firewall-cmd --reload
  success
 ```

````sh
[nathan@web ~]$ sudo firewall-cmd --list-all | grep 8709
  ports: 8709/tcp
  ```

🌞 Redémarrer le service
```sh
[nathan@web ~]$ sudo systemctl restart sshd
```

🌞 Effectuer une connexion SSH sur le nouveau port
```sh
PS C:\Users\gusta> ssh nathan@10.1.1.1
nathan@10.1.1.1's password:
Last login: Sun Dec  1 19:25:38 2024 from 10.1.1.100
[nathan@web ~]$ exit
logout
Connection to 10.1.1.1 closed.
PS C:\Users\gusta> ssh -p 8709 nathan@10.1.1.1
nathan@10.1.1.1's password:
Last login: Sun Dec  1 19:52:48 2024 from 10.1.1.100
```

✨ Bonus : affiner la conf du serveur SSH
```sh 
PermitEmptyPasswords no
PermitRootLogin no
AllowUsers nathan
PasswordAuthentication no
PublicKeyAuthentication yes
LoginGraceTime 60
MaxAuthTries 3
```

# Partie 2 : service Web
## II. Service HTTP

### 1. Mise en place

🌞 Installer le serveur NGINX
```sh
[nathan@web ~]$ sudo dnf install nginx
[sudo] password for nathan:
Rocky Linux 9 - BaseOS                                                                  8.5 kB/s | 4.1 kB     00:00
Rocky Linux 9 - AppStream                                                                15 kB/s | 4.5 kB     00:00
Rocky Linux 9 - Extras                                                                   10 kB/s | 2.9 kB     00:00
Dependencies resolved.
========================================================================================================================
 Package                         Architecture         Version                             Repository               Size
========================================================================================================================
Installing:
 nginx                           x86_64               2:1.20.1-20.el9.0.1                 appstream                36 k
Installing dependencies:
 nginx-core                      x86_64               2:1.20.1-20.el9.0.1                 appstream               566 k
 nginx-filesystem                noarch               2:1.20.1-20.el9.0.1                 appstream               8.4 k
 rocky-logos-httpd               noarch               90.15-2.el9                         appstream                24 k

Transaction Summary
========================================================================================================================
Install  4 Packages

Total download size: 634 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): nginx-filesystem-1.20.1-20.el9.0.1.noarch.rpm                                    113 kB/s | 8.4 kB     00:00
(2/4): rocky-logos-httpd-90.15-2.el9.noarch.rpm                                         261 kB/s |  24 kB     00:00
(3/4): nginx-1.20.1-20.el9.0.1.x86_64.rpm                                               335 kB/s |  36 kB     00:00
(4/4): nginx-core-1.20.1-20.el9.0.1.x86_64.rpm                                          2.6 MB/s | 566 kB     00:00
------------------------------------------------------------------------------------------------------------------------
Total                                                                                   1.2 MB/s | 634 kB     00:00
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                1/1
  Running scriptlet: nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    1/4
  Installing       : nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    1/4
  Installing       : nginx-core-2:1.20.1-20.el9.0.1.x86_64                                                          2/4
  Installing       : rocky-logos-httpd-90.15-2.el9.noarch                                                           3/4
  Installing       : nginx-2:1.20.1-20.el9.0.1.x86_64                                                               4/4
  Running scriptlet: nginx-2:1.20.1-20.el9.0.1.x86_64                                                               4/4
  Verifying        : rocky-logos-httpd-90.15-2.el9.noarch                                                           1/4
  Verifying        : nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                                                    2/4
  Verifying        : nginx-2:1.20.1-20.el9.0.1.x86_64                                                               3/4
  Verifying        : nginx-core-2:1.20.1-20.el9.0.1.x86_64                                                          4/4

Installed:
  nginx-2:1.20.1-20.el9.0.1.x86_64                              nginx-core-2:1.20.1-20.el9.0.1.x86_64
  nginx-filesystem-2:1.20.1-20.el9.0.1.noarch                   rocky-logos-httpd-90.15-2.el9.noarch

Complete!
```

🌞 Démarrer le service NGINX
```sh
[nathan@web ~]$ sudo systemctl start nginx
```

🌞 Déterminer sur quel port tourne NGINX
```sh
[nathan@web ~]$ sudo ss -lnpt | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1813,fd=6),("nginx",pid=1812,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1813,fd=7),("nginx",pid=1812,fd=7))
```

* Ouverture du port sur le Firewall
 ```sh 
[nathan@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[nathan@web ~]$ sudo firewall-cmd --reload
success
[nathan@web ~]$ sudo firewall-cmd --list-all | grep 80
  ports: 80/tcp
```
🌞 Déterminer les processus liés au service NGINX
```sh
[nathan@web ~]$ ps -ef | grep nginx
root        1812       1  0 20:06 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1813    1812  0 20:06 ?        00:00:00 nginx: worker process
nathan      1843    1618  0 20:11 pts/2    00:00:00 grep --color=auto nginx
```

🌞 Déterminer le nom de l'utilisateur qui lance NGINX
```sh
[nathan@web ~]$ sudo cat /etc/passwd | grep nginx
nginx:x:996:993:Nginx web server:/var/lib/nginx:/sbin/nologin
```

🌞 Test !
```sh
gusta@NATHANHO_AMB MINGW64 ~ (main)
$ curl http://10.1.1.1:80 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   375k      0 --:--:-- --:--:-- --:--:--  391k<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>

    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
```

### 2. Analyser la conf de NGINX

🌞 Déterminer le path du fichier de configuration de NGINX
```sh
[nathan@web ~]$ sudo find / -name "nginx"
[sudo] password for nathan:
/etc/logrotate.d/nginx
/etc/nginx
/var/lib/nginx
/var/log/nginx
/usr/sbin/nginx
/usr/lib64/nginx
/usr/share/nginx
```
```sh
[nathan@web ~]$ ls -al /etc/nginx
total 84
drwxr-xr-x.  4 root root 4096 Dec  1 20:05 .
drwxr-xr-x. 82 root root 8192 Dec  8 20:00 ..
drwxr-xr-x.  2 root root   25 Dec  2 06:37 conf.d
drwxr-xr-x.  2 root root    6 Nov  8 17:44 default.d
-rw-r--r--.  1 root root 1077 Nov  8 17:44 fastcgi.conf
-rw-r--r--.  1 root root 1077 Nov  8 17:44 fastcgi.conf.default
-rw-r--r--.  1 root root 1007 Nov  8 17:44 fastcgi_params
-rw-r--r--.  1 root root 1007 Nov  8 17:44 fastcgi_params.default
-rw-r--r--.  1 root root 2837 Nov  8 17:44 koi-utf
-rw-r--r--.  1 root root 2223 Nov  8 17:44 koi-win
-rw-r--r--.  1 root root 5231 Nov  8 17:44 mime.types
-rw-r--r--.  1 root root 5231 Nov  8 17:44 mime.types.default
-rw-r--r--.  1 root root 2335 Dec  2 07:22 nginx.conf
-rw-r--r--.  1 root root 2656 Nov  8 17:44 nginx.conf.default
-rw-r--r--.  1 root root  636 Nov  8 17:44 scgi_params
-rw-r--r--.  1 root root  636 Nov  8 17:44 scgi_params.default
-rw-r--r--.  1 root root  664 Nov  8 17:44 uwsgi_params
-rw-r--r--.  1 root root  664 Nov  8 17:44 uwsgi_params.default
-rw-r--r--.  1 root root 3610 Nov  8 17:44 win-utf
```

🌞 Trouver dans le fichier de conf

* les lignes qui permettent de faire tourner un site web d'accueil
```sh
[nathan@web ~]$ cat /etc/nginx/nginx.conf | grep "server" -A 10
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
--
# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }
```

* une ligne qui commence par include
 ```sh
[nathan@web ~]$ cat /etc/nginx/nginx.conf | grep "include"
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

* la ligne qui indique à NGINX qu'il doit s'exécuter en tant qu'un utilisateur spécifique
  ```sh
  [nathan@web ~]$ cat /etc/nginx/nginx.conf | grep "user"
  user nginx;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
  ```


 ### 3. Déployer un nouveau site web  
  
  🌞 Créer un site web
  ```sh
[nathan@web www]$ sudo rm -r tp1_parc
[nathan@web www]$ sudo mkdir tp1_parc
[nathan@web tp1_parc]$ sudo nano index.html
```

🌞 Gérer les permissions
```sh
[nathan@web tp1_parc]$ sudo chown nginx /var/www/tp1_parc
```

🌞 Adapter la conf NGINX
```sh
[nathan@web ~]$ echo $RANDOM
19479
[nathan@web ~]$ sudo nano /etc/nginx/conf.d/siuu_conf.conf
[nathan@web ~]$ sudo firewall-cmd --permanent --add-port=19479/tcp
success
[nathan@web ~]$ sudo firewall-cmd  --reload
success
[nathan@web ~]$ sudo systemctl restart nginx
[nathan@web ~]$ cd /etc/nginx/conf.d
[nathan@web conf.d]$ ls
siuu_conf.conf
[nathan@web conf.d]$
```
🌞 Visitez votre super site web
```sh
gusta@NATHANHO_AMB MINGW64 ~ (main)
$ curl http://10.1.1.1:19479 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    38  100    38    0     0    857      0 --:--:-- --:--:-- --:--:--   883
<h1>MEOW mon premier serveur web</h1>
```

# Partie 3 : service de monitoring
## III. Monitoring et alerting
### 1. Installation

🌞 Installer Netdata
```sh
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh --no-updates --stable-channel --disable-telemetry
```

### 2. Un peu d'analyse de service

🌞 Démarrer le service netdata
```sh
[nathan@monotoring ~]$ sudo systemctl start netdata
[nathan@monotoring ~]$ sudo systemctl status netdata
● netdata.service - Real time performance monitoring
     Loaded: loaded (/usr/lib/systemd/system/netdata.service; enabled; preset: enabled)
     Active: active (running) since Sun 2024-12-08 23:36:26 CET; 19s ago
    Process: 3827 ExecStartPre=/bin/mkdir -p /var/cache/netdata (code=exited, status=0/SUCCESS)
    Process: 3829 ExecStartPre=/bin/chown -R netdata /var/cache/netdata (code=exited, status=0/SUCCESS)
    Process: 3830 ExecStartPre=/bin/mkdir -p /run/netdata (code=exited, status=0/SUCCESS)
    Process: 3831 ExecStartPre=/bin/chown -R netdata /run/netdata (code=exited, status=0/SUCCESS)
   Main PID: 3832 (netdata)
      Tasks: 90 (limit: 11083)
     Memory: 97.0M
        CPU: 2.352s
     CGroup: /system.slice/netdata.service
             ├─3832 /usr/sbin/netdata -P /run/netdata/netdata.pid -D
             ├─3833 "spawn-plugins    " "  " "                        " "  "
             ├─4001 bash /usr/libexec/netdata/plugins.d/tc-qos-helper.sh 1
             ├─4016 /usr/libexec/netdata/plugins.d/apps.plugin 1
             ├─4018 /usr/libexec/netdata/plugins.d/debugfs.plugin 1
             ├─4019 /usr/libexec/netdata/plugins.d/ebpf.plugin 1
             ├─4020 /usr/libexec/netdata/plugins.d/go.d.plugin 1
             ├─4021 /usr/libexec/netdata/plugins.d/network-viewer.plugin 1
             ├─4024 /usr/libexec/netdata/plugins.d/systemd-journal.plugin 1
             └─4036 "spawn-setns                                         " " "

Dec 08 23:36:42 monotoring.tp1.b1 netdata[3832]: ALERT 'apps_group_file_descriptors_utilization' of instance 'app.khuge>
Dec 08 23:36:42 monotoring.tp1.b1 netdata[3832]: ALERT 'apps_group_file_descriptors_utilization' of instance 'app.xfs_f>
Dec 08 23:36:42 monotoring.tp1.b1 netdata[3832]: ALERT 'apps_group_file_descriptors_utilization' of instance 'app.syste>
Dec 08 23:36:42 monotoring.tp1.b1 netdata[3832]: ALERT 'apps_group_file_descriptors_utilization' of instance 'app.syste>
Dec 08 23:36:42 monotoring.tp1.b1 netdata[3832]: ALERT 'apps_group_file_descriptors_utilization' of instance 'app.deskt>
Dec 08 23:36:42 monotoring.tp1.b1 netdata[3832]: ALERT '10s_received_packets_storm' of instance 'net_packets.enp0s3' on>
lines 1-29
```

🌞 Déterminer sur quel port tourne Netdata
```sh
[nathan@monotoring ~]$ sudo ss -lnpt | grep netdata
LISTEN 0      4096       127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=3832,fd=52))
LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*    users:(("netdata",pid=3832,fd=6))
LISTEN 0      4096           [::1]:8125          [::]:*    users:(("netdata",pid=3832,fd=51))
LISTEN 0      4096            [::]:19999         [::]:*    users:(("netdata",pid=3832,fd=7))
```
* Ouvrit le port
  ```sh
  [nathan@monotoring ~]$ sudo firewall-cmd --permanent --add-port=19999/tcp
  Warning: ALREADY_ENABLED: 19999:tcp
  success
  [nathan@monotoring ~]$ sudo firewall --reload
 ```

🌞 Visiter l'interface Web
```sh
gusta@NATHANHO_AMB MINGW64 ~ (main)
$ curl http://10.1.1.2:19999 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html><html lang="en" dir="ltr"><head><meta charset="utf-8"/><title>Netdata</title><script>const CONFIG = {
      cache: {
        agentInfo: false,
        cloudToken: true,
        agentToken: true,
      }
    }

    // STATE MANAGEMENT ======================================================================== //
    const state = {
 39  106k   39 43429    0     0  1220k      0 --:--:-- --:--:-- --:--:-- 1247k
curl: (23) Failure writing output to destination, passed 14600 returned 1627
```

### 3. Ajouter un check

🌞 Ajouter un check
  * web de web.tp1.b1
```sh
[nathan@monotoring ~]$ cd /etc/netdata 2>/dev/null || cd /opt/netdata/etc/netdata
[nathan@monotoring netdata]$ sudo ./edit-config go.d/portcheck.conf
Copying '/etc/netdata/../../usr/lib/netdata/conf.d//go.d/portcheck.conf' to '/etc/netdata//go.d/portcheck.conf' ...
Editing '/etc/netdata/go.d/portcheck.conf' ...
[nathan@monotoring netdata]$ sudo systemctl restart netdata

jobs:
 - name: Web_web.tp1.b1
  host: 10.0.0.1
  ports:
      -19479
```

🌞 Ajouter un check
 * serveur SSH de web.tp1.b1
   ```sh
   [nathan@monotoring netdata]$ sudo ./edit-config go.d/portcheck.conf
   [sudo] password for nathan:
   Editing '/etc/netdata/go.d/portcheck.conf' ...
   [nathan@monotoring netdata]$ sudo systemctl restart netdata
   
  - name: SSH_web.tp1.b1
    host: 10.0.0.2
    ports:
        -22
     ```

   ### 4. Ajouter des alertes 
  
  🌞 Configurer l'alerting avec Discord   
  ```sh
# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook by following the official documentation -
# https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1315466997664059402/DOaiQauyL-0hvdEEju-i_6QrKxz4dqRYE2abr7MwFzYqmnYBC0h_mtJz0coqMJX7deKq"

# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="alerts"
```

🌞 Tester que ça fonctionne
```sh







  




  

                      
  








