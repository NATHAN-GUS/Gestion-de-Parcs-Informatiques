#!/bin/bash
echo " Win win script lanceu"
tar -czvf /mnt/music_backup/music_$(date +"%y%m%d_%H%M%S").tar.gz -C /srv/music
echo " Music telehr succes : music_$(date +"%y%m%d_%H%M%S").tar.gz"

