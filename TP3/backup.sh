#!/bin/bash

# SOURCE="/srv/music"
BACKUP_DIR="/mnt/music_backup"
LOG=$(date +"%y%m%d_%H%M%S")
NAME_ARCH="music_${LOG}.tar.gz"

tar -czf "$BACKUP_DIR/$NAME_ARCH" -C "$SOURCE" .

if [[ $? -eq 0 ]]; then
    echo "Sauvegarde réussie : $BACKUP_DIR/$ARCHIVE_NAME"
else
    echo "Erreur lors de la création de la sauvegarde."
fi
