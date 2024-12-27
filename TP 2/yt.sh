
#!/bin/bash

# Vérifier si /opt/yt/downloads/ existe
if [[ ! -d "/opt/yt/downloads/" ]]; then
    echo "/opt/yt/downloads/ does not exist. Please create the directory."
    exit
fi

# Vérifier si /var/log/yt/ existe
if [[ ! -d "/var/log/yt/" ]]; then
    echo "/var/log/yt/ does not exist. Please create the directory."
    exit
fi

# Récupérer l'URL de la vidéo
URL=$1

# Récupérer le nom de la vidéo avec yt-dlp
NOM_VIDEO=$(yt-dlp --get-filename -o "%(title)s" "$URL" 2>/dev/null)

# Créer le dossier pour la vidéo
mkdir -p "/opt/yt/downloads/$NOM_VIDEO"

# Télécharger la vidéo
yt-dlp -o "/opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4" "$URL"

# Télécharger la description de la vidéo
yt-dlp --write-description --skip-download -o "/opt/yt/downloads/$NOM_VIDEO/description" "$URL"

# Générer la date pour le log
DATE_LOG=$(date '+%y/%m/%d %H:%M:%S')

# Écrire dans le fichier de log
echo "[$DATE_LOG] Video $URL was downloaded. File path : /opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4" >> /var/log/yt/do>

# Sortie personnalisée                                                                                                  
echo "Video $URL was downloaded."
echo "File path : /opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4"
