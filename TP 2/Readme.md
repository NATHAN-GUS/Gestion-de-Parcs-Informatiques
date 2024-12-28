# Partie I : Des beaux one-liners
## 2. Let's go

🌞 Afficher la quantité d'espace disque disponible
```sh
[nathan@node1 ~]$ df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  4.0M     0  4.0M   0% /dev
tmpfs                     888M     0  888M   0% /dev/shm
tmpfs                     355M  5.0M  350M   2% /run
/dev/mapper/rl_vbox-root  8.0G  2.2G  5.8G  28% /
/dev/sda1                 960M  319M  642M  34% /boot
tmpfs                     178M     0  178M   0% /run/user/1000
[nathan@node1 ~]$  df -h  | grep /dev/mapper
/dev/mapper/rl_vbox-root  8.0G  2.2G  5.8G  28% /
[nathan@node1 ~]$  df -h  | grep /dev/mapper | tr -s " " | cut -d' ' -f4
5.8G
```
🌞 Afficher combien de fichiers il est possible de créer
```sh
[nathan@node1 ~]$ df -i
Filesystem                Inodes IUsed   IFree IUse% Mounted on
devtmpfs                  221952   391  221561    1% /dev
tmpfs                     227160     1  227159    1% /dev/shm
tmpfs                     819200   603  818597    1% /run
/dev/mapper/rl_vbox-root 4192256 44205 4148051    2% /
/dev/sda1                 524288   366  523922    1% /boot
tmpfs                      45432    14   45418    1% /run/user/1000
[nathan@node1 ~]$  df -i  | grep /dev/mapper | tr -s " " | cut -d' ' -f4
4148051
```
🌞 Afficher l'heure et la date
```sh
[nathan@node1 ~]$ date +"%d/%m/%y %H:%M:%S"
23/12/24 14:14:27
```
🌞 Afficher la version de l'OS précise
```sh
[nathan@node1 ~]$ source /etc/os-release
echo $PRETTY_NAME
Rocky Linux 9.5 (Blue Onyx)
```
🌞 Afficher la version du kernel en cours d'utilisation précise
```sh
[nathan@node1 ~]$ uname -r
5.14.0-503.16.1.el9_5.x86_64
```
🌞 Afficher le chemin vers la commande python3
```sh
[nathan@node1 ~]$ which python3
/usr/bin/python3
```
🌞 Afficher l'utilisateur actuellement connecté
```sh
[nathan@node1 ~]$ echo $USER
nathan
```
🌞 Afficher le shell par défaut de votre utilisateur actuellement connecté
```sh
[nathan@node1 ~]$ cat /etc/passwd | grep $USER
nathan:x:1000:1000:nathan:/home/nathan:/bin/bash
[nathan@node1 ~]$ cat /etc/passwd | grep $USER | cut -d: -f7
/bin/bash
```
🌞 Afficher le nombre de paquets installés
```sh
[nathan@node1 ~]$ rpm -qa | wc -l
478
```
🌞 Afficher le nombre de ports en écoute
```sh
[nathan@node1 ~]$ sudo ss -lnpt
[sudo] password for nathan:
State          Recv-Q         Send-Q                  Local Address:Port                   Peer Address:Port         Process
LISTEN         0              128                           0.0.0.0:22                          0.0.0.0:*             users:(("sshd",pid=706,fd=3))
LISTEN         0              128                              [::]:22                             [::]:*             users:(("sshd",pid=706,fd=4))
[nathan@node1 ~]$ ss -lnpt | grep LISTEN | wc -l
2
```

# Partie II : Un premier ptit script
## 2. Premiers pas scripting
🌞 Ecrire un script qui produit exactement l'affichage demandé 
```sh
#!/bin/bash

USER=$(whoami)
DATE=$(date +"%d/%m/%y %H:%M:%S")
SHELL=$(cat /etc/passwd | grep $USER | cut -d: -f7)
OS=(source /etc/os-release
echo $PRETTY_NAME)
KERNEL=$(uname -r)
RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK=$(df -h  | grep /dev/mapper | tr -s " " | cut -d' ' -f4)
INODE=$( df -i  | grep /dev/mapper | tr -s " " | cut -d' ' -f4)
PACKETS=$(rpm -qa | wc -l)
PORTS=$(ss -lnpt | grep LISTEN | wc -l)
PYTHON=$(which python3)

echo "Salu a toa $USER."
echo "Nouvelle connexion $DATE."
echo "Connecté avec le shell $SHELL."
echo "OS : $OS - Kernel : $KERNEL"
echo "Ressources :"
echo "  - $RAM RAM dispo"
echo "  - $DISK espace disque dispo"
echo "  - $INODE fichiers restants"
echo "Actuellement :"
echo "  - $PACKETS paquets installés"
echo "  - $PORTS port(s) ouvert(s)"
echo "Python est bien installé sur la machine au chemin : $PYTHON"
```
```sh
[nathan@node1 opt]$ ./id.sh
Salu a toa nathan.
Nouvelle connexion 23/12/24 14:59:24.
Connecté avec le shell /bin/bash.
OS : source - Kernel : 5.14.0-503.16.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
  - 5.8G espace disque dispo
  - 4148051 fichiers restants
Actuellement :
  - 478 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
```

## 3. Amélioration du script

🌞 Le script id.sh affiche l'état du firewall et l'URL vers une photo de chat random
```sh
[nathan@node1 opt]$ sudo  nano id.sh
#!/bin/bash

USER=$(whoami)
DATE=$(date +"%d/%m/%y %H:%M:%S")
SHELL=$(cat /etc/passwd | grep $USER | cut -d: -f7)
OS=(source /etc/os-release
echo $PRETTY_NAME)
KERNEL=$(uname -r)
RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK=$(df -h  | grep /dev/mapper | tr -s " " | cut -d' ' -f4)
INODE=$( df -i  | grep /dev/mapper | tr -s " " | cut -d' ' -f4)
PACKETS=$(rpm -qa | wc -l)
PORTS=$(ss -lnpt | grep LISTEN | wc -l)
PYTHON=$(which python3)
if systemctl is-active --quiet firewalld; then
    FIREWALL="Le firewall est actif."
else
    FIREWALL="Le firewall est inactif."
fi
CAT_URL=$(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url')

echo "Salu a toa $USER."
echo "Nouvelle connexion $DATE."
echo "Connecté avec le shell $SHELL."
echo "OS : $OS - Kernel : $KERNEL"
echo "Ressources :"
echo "  - $RAM RAM dispo"
echo "  - $DISK espace disque dispo"
echo "  - $INODE fichiers restants"
echo "Actuellement :"
echo "  - $PACKETS paquets installés"
echo "  - $PORTS port(s) ouvert(s)"
echo "Python est bien installé sur la machine au chemin : $PYTHON"
echo "$FIREWALL"
echo "Voilà ta photo de chat : $CAT_URL"
```

```sh
Salu a toa nathan.
Nouvelle connexion 23/12/24 15:20:09.
Connecté avec le shell /bin/bash.
OS : source - Kernel : 5.14.0-503.16.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
  - 5.8G espace disque dispo
  - 4148051 fichiers restants
Actuellement :
  - 478 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
Le firewall est actif.
Voilà ta photo de chat : https://cdn2.thecatapi.com/images/d76.jpg
```

# 4. Bannière

🌞 Stocker le fichier id.sh dans /opt
```sh
[nathan@node1 opt]$ ls
id.sh
```
🌞 Prouvez que tout le monde peut exécuter le script
```sh
[nathan@node1 opt]$ ls -al /opt/id.sh
-rwxr-xr-x. 1 root root 1145 Dec 23 15:20 /opt/id.sh
```
🌞 Ajouter l'exécution au .bashrc de votre utilisateur
```sh
[nathan@node1 opt]$ nano ~/.bashrc
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi

unset
/opt/id.sh
```

```sh
PS C:\Users\gusta> ssh nathan@10.2.1.1
nathan@10.2.1.1's password:
Last login: Mon Dec 23 14:51:48 2024 from 10.2.1.100
Salu a toa nathan.
Nouvelle connexion 23/12/24 15:28:41.
Connecté avec le shell /bin/bash.
OS : source - Kernel : 5.14.0-503.16.1.el9_5.x86_64
Ressources :
  - 1.4Gi RAM dispo
  - 5.8G espace disque dispo
  - 4148047 fichiers restants
Actuellement :
  - 478 paquets installés
  - 2 port(s) ouvert(s)
Python est bien installé sur la machine au chemin : /usr/bin/python3
Le firewall est actif.
Voilà ta photo de chat : https://cdn2.thecatapi.com/images/dtg.jpg
[nathan@node1 ~]$
```

# 5. Bonus : des paillettes

```sh
#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BOLD="\e[1m"
NC="\e[0m" # No Color

USER=$(whoami)
DATE=$(date +"%d/%m/%y %H:%M:%S")
SHELL=$(cat /etc/passwd | grep $USER | cut -d: -f7)
OS=(source /etc/os-release
echo $PRETTY_NAME)
KERNEL=$(uname -r)
RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7)
DISK=$(df -h  | grep /dev/mapper | tr -s " " | cut -d' ' -f4)
INODE=$( df -i  | grep /dev/mapper | tr -s " " | cut -d' ' -f4)
PACKETS=$(rpm -qa | wc -l)
PORTS=$(ss -lnpt | grep LISTEN | wc -l)
PYTHON=$(which python3)
if systemctl is-active --quiet firewalld; then
    FIREWALL="Le firewall est actif.${NC}"
else
    FIREWALL="Le firewall est inactif.${NC}"
fi
CAT_URL=$(curl -s https://api.thecatapi.com/v1/images/search | jq -r '.[0].url')

echo -e "${BOLD}Salu a toa ${CYAN}$USER${NC}."
echo -e "Nouvelle connexion ${YELLOW}$DATE${NC}."
echo -e "Connecté avec le shell ${MAGENTA}$SHELL${NC}."
echo -e "OS : ${BLUE}$OS${NC} - Kernel : ${BLUE}$KERNEL${NC}"
echo -e "${BOLD}Ressources :${NC}"
echo -e "  - ${GREEN}$RAM${NC} RAM dispo"
echo -e "  - ${GREEN}$DISK${NC} espace disque dispo"
echo -e "  - ${GREEN}$INODE${NC} fichiers restants"
echo -e "${BOLD}Actuellement :${NC}"
echo -e "  - ${CYAN}$PACKETS${NC} paquets installés"
echo -e "  - ${CYAN}$PORTS${NC} port(s) ouvert(s)"
echo -e "Python est bien installé sur la machine au chemin : ${MAGENTA}$PYTHON${NC}"
echo -e "$FIREWALL"
echo -e "Voilà ta photo de chat : ${BLUE}$CAT_URL${NC}"
```

# Partie III : Script yt-dlp
## 1. Premier script yt-dlp
### B. Rendu attendu
- Exemple d'éxécution 
```sh
[nathan@node1 yt]$ ./yt.sh https://www.youtube.com/watch?v=AbILPD3ZsZY
Video https://www.youtube.com/watch?v=AbILPD3ZsZY was downloaded.
File path : /opt/yt/downloads/Coca-Cola to Turn Up the Moment/Coca-Cola to Turn Up the Moment.mp4
```
- Logs
  ```sh
  [nathan@node1 yt]$ cat /var/log/yt/download.log
  [24/12/27 02:39:34] Video https://www.youtube.com/watch?v=AbILPD3ZsZY was downloaded. File path : /opt/yt/downloads/Coca-Cola to Turn Up the Moment/Coca-Cola to 
  Turn Up the Moment.mp4
 ```
- Description 
```sh
[nathan@node1 yt]$ ls
downloads  yt.sh
[nathan@node1 yt]$ cd downloads
[nathan@node1 downloads]$ ls
'Coca-Cola to Turn Up the Moment'
```
-Dossiers
```sh
[nathan@node1 yt]$ ls -d /var/log/yt/
/var/log/yt/
[nathan@node1 yt]$ ls -d /var/log/yt/download.log
/var/log/yt/download.log
```
  
# 2. MAKE IT A SERVICE
## C. Rendu attendu

🌞 Toutes les commandes que vous utilisez 
   ```sh
   [nathan@node1 system]$ sudo useradd -r -s /sbin/nologin yt
    sudo chown -R yt:yt /opt/yt
    sudo chown -R yt:yt /var/log/yt/
    sudo usermod -L yt ( empeche l'utilisateur de se connecter)
    sudo usermod -s /usr/sbin/nologin yt
   ```





  







