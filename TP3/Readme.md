# Partie II : Serveur de streaming
## 1. Préparation de la machine

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

# 2. Installation du service de streaming

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
    <meta property="og:type" content="article">[nathan@monitoring ~]$ sudo /opt/autoconfig.sh monitoring.tp3.b1
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
```sh

    <meta id="themeColor" name="theme-color" content="#202020">
```

# Partie III : Serveur de monitoring
🌞 Dérouler le script autoconfig.sh développé à la partie I
```sh
