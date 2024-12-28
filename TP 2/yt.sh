
#!/bin/bash

# Vérifie si le dossier de téléchargement existe
if [[ ! -d "/opt/yt/downloads/" ]]; then
    echo "/opt/yt/downloads/ does not exist. Please create the directory."
    exit
fi

# Vérifie si le dossier de log existe
if [[ ! -d "/var/log/yt/" ]]; then
    echo "/var/log/yt/ does not exist. Please create the directory."
    exit
fi

# Récupère l'URL passée en argument
URL=$1

# Récupère le nom de la vidéo à partir de l'URL
NOM_VIDEO=$(yt-dlp --get-filename -o "%(title)s" "$URL" 2>/dev/null)

# Crée le dossier pour la vidéo
mkdir -p "/opt/yt/downloads/$NOM_VIDEO"

# Télécharge la vidéo
yt-dlp -o "/opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4" "$URL" > /dev/null 2>&1

# Télécharge la description de la vidéo
yt-dlp --write-description --skip-download -o "/opt/yt/downloads/$NOM_VIDEO/description" "$URL" > /dev/null 2>&1

# Formatte la date pour le log
DATE_LOG=$(date '+%y/%m/%d %H:%M:%S')

# Ajoute une ligne de log
echo "[$DATE_LOG] Video $URL was downloaded. File path : /opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4" >> /var/log/yt/download.log

# Affiche la sortie personnalisée dans le terminal
echo "Video $URL was downloaded."
echo "File path : /opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4"
