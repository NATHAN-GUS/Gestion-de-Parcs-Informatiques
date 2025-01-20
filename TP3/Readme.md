# Partie II : Serveur de streaming
###  1. Préparation de la machine

🌞 Exécution du script autoconfig.sh développé à la partie I
```sh
[nathan@music ~]$ sudo /opt/autoconfig.sh music.tp3.b1
11:33:30 [INFO] Le script d'autoconfiguration a démarré
11:33:30 [INFO] Le script a bien été lancé en root
11:33:30 [INFO] Désactivation de SELinux définitive (fichier de config)
11:33:30 [INFO] Service de firewalling firewalld est activé
11:33:30 [WARN] Le serveur SSH tourne toujours sur le port 22/TCP.
11:33:30 [INFO] Nouveau port choisi : 12578.
11:33:30 [INFO] Configuration SSH modifiée pour utiliser le port 12578.
11:33:30 [INFO] Service SSH redémarré.
success
success
success
11:33:32 [INFO] Port 22 fermé et 12578 ouvert dans le firewall.
 Le nom goatesque de la machine devient music.tp3.b1
11:33:32 [INFO] L'utilisateur root est déjà dans le groupe wheel.
11:33:32 [INFO] Le script d'autoconfiguration s'est correctement déroulé
```

🌞 Création d'un dossier où on hébergera les fichiers de musique
```sh
[nathan@music ~]$ cd /srv
[nathan@music srv]$
[nathan@music srv]$ sudo mkdir music
[sudo] password for nathan:
[nathan@music srv]$
[nathan@music srv]$ ls
music
```

🌞 Déposez quelques fichiers son là dedans
```sh
 scp 'David Okit - Les choses (Visualizer Officiel).mp3' nathan@10.3.1.11:/srv/music/
 scp 'Don Miguelo - Y Que Fue_.mp3' nathan@10.3.1.11:/srv/music/
 scp 'Saweetie - I Want You This Christmas (Official Music Video).mp3' nathan@10.3.1.11:/srv/music/
 scp 'Tiakola x Genezio x Prototype - PONA NINI (Visual Mixtape).mp3' nathan@10.3.1.11:/srv/music/
```

```sh
[nathan@music music]$ ls
'David Okit - Les choses (Visualizer Officiel).mp3'  'Saweetie - I Want You This Christmas (Official Music Video).mp3'
'Don Miguelo - Y Que Fue_.mp3'                       'Tiakola x Genezio x Prototype - PONA NINI (Visual Mixtape).mp3'
```

### 2. Installation du service de streaming

🌞 Installer le paquet jellyfin
```sh
[nathan@music music]$ sudo dnf install jellyfin
```
🌞 Lancer le service jellyfin
```sh
[nathan@music music]$ sudo systemctl start jellyfin
[nathan@music ~]$ sudo systemctl status jellyfin
[sudo] password for nathan:
● jellyfin.service - Jellyfin Media Server
     Loaded: loaded (/usr/lib/systemd/system/jellyfin.service; disabled; preset: disabled)
    Drop-In: /etc/systemd/system/jellyfin.service.d
             └─override.conf
     Active: active (running) since Sat 2025-01-18 21:02:41 CET; 14h ago
   Main PID: 12620 (jellyfin)
      Tasks: 20 (limit: 11083)
     Memory: 151.7M
        CPU: 54.249s
     CGroup: /system.slice/jellyfin.service
             └─12620 /usr/lib64/jellyfin/jellyfin --webdir=/usr/share/jellyfin-web --restartpath=/usr/libexec/jellyfin/restart.sh
```

🌞 Afficher la liste des ports TCP en écoute
```sh
[nathan@music music]$ sudo ss -lnpt | grep jellyfin
LISTEN 0      512          0.0.0.0:8096      0.0.0.0:*    users:(("jellyfin",pid=12620,fd=310))
```

🌞 Ouvrir le port derrière lequel Jellyfin écoute
```sh
[nathan@music music]$ sudo firewall-cmd --add-port=8096/tcp --permanent
success
[nathan@music music]$ sudo firewall-cmd --reload
success
[nathan@music music]$ sudo firewall-cmd --list-ports
8096/tcp 8752/tcp 29228/tcp
```

🌞 Visitez l'interface Web !
```sh
 curl -L http://10.3.1.11:8096

<!doctype html>
<html class="preload">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover">
    <link rel="manifest" href="64d966784cd77b03a79c.json">
    <meta name="format-detection" content="telephone=no">
    <meta name="msapplication-tap-highlight" content="no">
    <meta http-equiv="X-UA-Compatibility" content="IE=Edge">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="application-name" content="Jellyfin">
    <meta name="robots" content="noindex, nofollow, noarchive">
    <meta name="referrer" content="no-referrer">
    <meta property="og:title" content="Jellyfin">
    <meta property="og:site_name" content="Jellyfin">
    <meta property="og:url" content="http://jellyfin.org">
    <meta property="og:description" content="The Free Software Media System">
    <meta property="og:type" content="article">

```

# Partie III : Serveur de monitoring
🌞 Dérouler le script autoconfig.sh développé à la partie I
```sh
[nathan@monitoring ~]$ sudo /opt/autoconfig.sh monitoring.tp3.b1
15:03:30 [INFO] Le script d'autoconfiguration a démarré
15:03:30 [INFO] Le script a bien été lancé en root
15:03:30 [WARN] SELinux est toujours activé !
15:03:30 [INFO] Désactivation de SELinux temporaire (setenforce)
15:03:30 [INFO] Désactivation de SELinux définitive (fichier de config)
15:03:30 [INFO] Service de firewalling firewalld est activé
15:03:30 [WARN] Le serveur SSH tourne toujours sur le port 22/TCP.
15:03:30 [INFO] Nouveau port choisi : 7120.
15:03:30 [INFO] Configuration SSH modifiée pour utiliser le port 7120.
15:03:30 [INFO] Service SSH redémarré.
success
success
success
15:03:33 [INFO] Port 22 fermé et 7120 ouvert dans le firewall.
 Le nom goatesque de la machine devient monitoring.tp3.b1
15:03:33 [WARN] L'utilisateur root n'est pas dans le groupe wheel !
15:03:33 [INFO] Le script d'autoconfiguration
```

🌞 Installer Netdata

-Commande
```sh
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh --no-updates --stable-channel --disable-telemetry
```
-Firewall
```sh
[nathan@monitoring ~]$ sudo systemctl start netdata
[nathan@monitoring ~]$ sudo ss -lntp
State              Recv-Q             Send-Q                         Local Address:Port                          Peer Address:Port            Process
LISTEN             0                  4096                                 0.0.0.0:19999                              0.0.0.0:*                users:(("netdata",pid=792,fd=6))
LISTEN             0                  4096                               127.0.0.1:8125                               0.0.0.0:*                users:(("netdata",pid=792,fd=84))
LISTEN             0                  128                                  0.0.0.0:22                                 0.0.0.0:*                users:(("sshd",pid=7415,fd=3))
LISTEN             0                  4096                                   [::1]:8125                                  [::]:*                users:(("netdata",pid=792,fd=80))
LISTEN             0                  4096                                    [::]:19999                                 [::]:*                users:(("netdata",pid=792,fd=7))
LISTEN             0                  128                                     [::]:22                                    [::]:*                users:(("sshd",pid=7415,fd=4))

[nathan@monitoring ~]$ sudo firewall-cmd --permanent --add-port=8125/tcp
success
[nathan@monitoring ~]$  sudo firewall-cmd --reload
success
```
🌞 Ajouter un check TCP
-commande
```sh
[nathan@monitoring ~]$ cd /etc/netdata 2>/dev/null || cd /opt/netdata/etc/netdata
[nathan@monitoring netdata]$ sudo ./edit-config go.d/portcheck.conf
```
-check
```sh
jobs:
 - name:jellyfin
   host: 10.3.1.11
   ports:
        - 8096
```

🌞 Ajout d'une alerte Discord
-commande
```sh
[nathan@monitoring netdata]$ sudo nano /etc/netdata/health_alarm_notify.conf
```
-config alert
```sh
# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook by following the official documentation -
# https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1330544266589638778/JHH7puNtgPlqWx1_fL0U1a4FCOYgDwmTBH-UtM9Rgb7f2HmHF7_nFDGzojAjkGUvvzoH"

# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="alerts"
```
```sh
[nathan@monitoring netdata]$ sudo systemctl restart netdata
```

# Partie IV : Serveur de backup
###  3. Gestion du disque dur

🌞 Partitionner le disque dur
```sh
[nathan@backup ~]$  sudo pvcreate /dev/sdb
[sudo] password for nathan:
  Physical volume "/dev/sdb" successfully created.
[nathan@backup ~]$  sudo pvs
  PV         VG      Fmt  Attr PSize   PFree
  /dev/sda2  rl_vbox lvm2 a--  <19.00g    0
  /dev/sdb           lvm2 ---    5.00g 5.00g
[nathan@backup ~]$ sudo vgcreate data /dev/sdb
  Volume group "data" successfully created
[nathan@backup ~]$ sudo vgs
  VG      #PV #LV #SN Attr   VSize   VFree
  data      1   0   0 wz--n-  <5.00g <5.00g
  rl_vbox   1   2   0 wz--n- <19.00g     0
[nathan@backup ~]$ sudo lvcreate -L 5000MB data -n backup_data
[sudo] password for nathan:
  Logical volume "backup_data" created.
[nathan@backup ~]$ sudo lvs
  LV          VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  backup_data data    -wi-a-----   4.88g
  root        rl_vbox -wi-ao---- <17.00g
  swap        rl_vbox -wi-ao----   2.00g
```

🌞 Formater la partition créée
```sh
[nathan@backup ~]$ sudo mkfs.ext4 /dev/data/backup_data
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1280000 4k blocks and 320000 inodes
Filesystem UUID: 05feddb9-e23c-40eb-9acf-dea93da664b6
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

🌞 Monter la partition
```sh
[nathan@backup ~]$ sudo mkdir /mnt/backup
[nathan@backup ~]$ sudo mount /dev/data/backup_data /mnt/backup
[nathan@backup ~]$ df -h
Filesystem                    Size  Used Avail Use% Mounted on
devtmpfs                      4.0M     0  4.0M   0% /dev
tmpfs                         888M     0  888M   0% /dev/shm
tmpfs                         355M  5.0M  350M   2% /run
/dev/mapper/rl_vbox-root       17G  1.3G   16G   8% /
/dev/sda1                     960M  230M  731M  24% /boot
tmpfs                         178M     0  178M   0% /run/user/1000
/dev/mapper/data-backup_data  4.8G   24K  4.5G   1% /mnt/backup
[nathan@backup ~]$ df -h | grep backup
/dev/mapper/data-backup_data  4.8G   24K  4.5G   1% /mnt/backup
```

🌞 Configurer un montage automatique de la partition
```sh
[nathan@backup ~]$ sudo nano /etc/fstab
[sudo] password for nathan:
```sh Ajout de : /dev/data/backup_data  /mnt/backup  ext4  defaults  0 2```
[nathan@backup ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
/mnt/backup              : already mounted
[nathan@backup ~]$ sudo umount /mnt/backup
[nathan@backup ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/backup does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
/mnt/backup              : successfully mounted
```

### 4. Service NFS
#### A. El servor

🌞 Installer et configurer un service NFS
- Command
```sh
[nathan@backup ~]$ sudo dnf install nfs-utils

- Config
```sh
[nathan@backup ~]$ sudo mkdir /var/nfs/general -p
[nathan@backup ~]$ ls -dl /var/nfs/general
drwxr-xr-x. 2 root root 6 Jan 19 23:33 /var/nfs/general
[nathan@backup ~]$ sudo chown nobody /var/nfs/general
[nathan@backup ~]$ sudo nano /etc/exports
 Ajout des lignes suivantes :
/mnt/backup 10.3.1.11(rw,sync,no_root_squash,no_subtree_check)

- Recharger les Exports:
[nathan@backup ~]$ sudo exportfs -ra

- visual
[nathan@backup ~]$  sudo systemctl enable nfs-server
[nathan@backup ~]$ sudo systemctl start nfs-server
[nathan@backup ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; preset: disabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Sun 2025-01-19 23:47:05 CET; 59min ago
       Docs: man:rpc.nfsd(8)
             man:exportfs(8)
   Main PID: 12348 (code=exited, status=0/SUCCESS)
        CPU: 60ms
```

-Firewall 
```sh
[nathan@backup ~]$ sudo firewall-cmd --permanent --add-service=nfs
success
[nathan@backup ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
[nathan@backup ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[nathan@backup ~]$ sudo firewall-cmd --reload
success
[nathan@backup ~]$ sudo firewall-cmd --permanent --list-all | grep services
[sudo] password for nathan:
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
```

🌞 Déterminer sur quel port écoute le service NFS
```sh
[nathan@backup ~]$ sudo ss -lntp | grep "rpc"
LISTEN 0      4096         0.0.0.0:111        0.0.0.0:*    users:(("rpcbind",pid=12320,fd=4),("systemd",pid=1,fd=41))
LISTEN 0      4096         0.0.0.0:51827      0.0.0.0:*    users:(("rpc.statd",pid=12322,fd=8))
LISTEN 0      4096         0.0.0.0:20048      0.0.0.0:*    users:(("rpc.mountd",pid=12326,fd=5))
LISTEN 0      4096            [::]:111           [::]:*    users:(("rpcbind",pid=12320,fd=6),("systemd",pid=1,fd=45))
LISTEN 0      4096            [::]:44491         [::]:*    users:(("rpc.statd",pid=12322,fd=10))
LISTEN 0      4096            [::]:20048         [::]:*    users:(("rpc.mountd",pid=12326,fd=7))
```

#### B. El cliente

🌞 Installer les outils NFS
```sh
sudo dnf install nfs-utils
```

🌞 Essayer d'accéder au dossier partagé
```sh
[nathan@music ~]$ sudo mkdir /mnt/music_backup
[nathan@music ~]$ sudo mount 10.3.1.13:/mnt/backup /mnt/music_backup
[nathan@music ~]$ cd /mnt/music_backup/
[nathan@music music_backup]$ echo "mypate full chium" | sudo tee /mnt/music_backup/test.txt
[sudo] password for nathan:
mypate full chium
[nathan@music music_backup]$ echo "piupiupiupiu" | sudo tee -a /mnt/music_backup/test.txt
piupiupiupiu
[nathan@music music_backup]$
[nathan@music music_backup]$ cat /mnt/music_backup/test.txt
mypate full chium
piupiupiupiu
[nathan@music music_backup]$ sudo rm /mnt/music_backup/test.txt
[nathan@music music_backup]$ ls
[nathan@music music_backup]$
```

🌞 Configurer un montage automatique
```sh
[nathan@music music_backup]$ sudo nano /etc/fstab
10.3.1.13:/mnt/backup  /mnt/music_backup  nfs  defaults,_netdev  0 0
```

#### 5. Service de backup




























