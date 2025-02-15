#!/bin/bash

log() {
    echo "$(date +%H:%M:%S) [$1] ${@:2}"
}

if [[ $(id -u) -ne 0 ]]; then
   log "ERROR" "Ce script doit être exécuté en tant que root. Veuillez réessayer avec les privilèges nécessaires."
   exit 1
fi

log "INFO" "Le script d'autoconfiguration a démarré"

log "INFO" "Le script a bien été lancé en root"

if [[ "$(sestatus | grep 'Current mode' | awk '{print $3}')" != "enforcing" ]]; then
    log "WARN" "SELinux est toujours activé !"
    log "INFO" "Désactivation de SELinux temporaire (setenforce)"
    setenforce 0
fi

if [[ "$(grep 'SELINUX=' /etc/selinux/config | awk '{print $2}')" != "enforcing" ]]; then
    log "INFO" "Désactivation de SELinux définitive (fichier de config)"
    sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
fi

if [[ "$(systemctl is-active firewalld)" != "active" ]]; then
    log "ERROR" "Le firewall (firewalld) n'est pas actif. Veuillez activer le firewall avant de continuer."

    else
    log "INFO" "Service de firewalling firewalld est activé"
fi


if ss -tuln | grep -q ':22'; then
    echo "$(date +%H:%M:%S) [WARN] Le serveur SSH tourne toujours sur le port 22/TCP."


    new_port=$((RANDOM % (65535 - 1025) + 1025))
    echo "$(date +%H:%M:%S) [INFO] Nouveau port choisi : $new_port."


    sed -i "s/Port 22/Port $new_port/" /etc/ssh/sshd_config
    echo "$(date +%H:%M:%S) [INFO] Configuration SSH modifiée pour utiliser le port $new_port."


    systemctl restart sshd
    echo "$(date +%H:%M:%S) [INFO] Service SSH redémarré."


firewall-cmd --permanent --remove-port=22/tcp
firewall-cmd --permanent --add-port=$new_port/tcp
firewall-cmd --reload
echo "$(date +%H:%M:%S) [INFO] Port 22 fermé et $new_port ouvert dans le firewall."
fi
if [ "$(hostname)" = "localhost" ] || [ "$(hostname)" = "vbox" ];
then
echo "$(date +%H:%M:%S) [WARN] Toujours en localhost"
    if [ -z "$1" ];
    then
        echo "Fournit un nom de machine en argument"
        exit
    else
        hostnamectl set-hostname "$1"
        echo "$(date +%H:%M:%S) [INFO] Nom de machine modifié en $(hostname)"
    fi
else
    echo " Le nom goatesque de la machine devient $(hostname)"
fi


if id "$(whoami)" &>/dev/null; then
    if [[ ! $(groups "$(whoami)" | grep -o "\bwheel\b") ]]; then
        log "WARN" "L'utilisateur $(whoami) n'est pas dans le groupe wheel !"
        log "INFO" "Ajout de l'utilisateur $(whoami) au groupe wheel"
        sudo usermod -aG wheel "$(whoami)"
    else
        log "INFO" "L'utilisateur $(whoami) est déjà dans le groupe wheel."
        fi
fi
log "INFO" "Le script d'autoconfiguration s'est correctement déroulé"

