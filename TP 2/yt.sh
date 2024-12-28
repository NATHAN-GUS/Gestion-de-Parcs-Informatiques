
#!/bin/bash

if [[ ! -d "/opt/yt/downloads/" ]]; then
    echo "/opt/yt/downloads/ does not exist. Please create the directory."
    exit
fi

if [[ ! -d "/var/log/yt/" ]]; then
    echo "/var/log/yt/ does not exist. Please create the directory."
    exit
fi

URL=$1

NOM_VIDEO=$(yt-dlp --get-filename -o "%(title)s" "$URL" 2>/dev/null)

mkdir -p "/opt/yt/downloads/$NOM_VIDEO"

yt-dlp -o "/opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4" "$URL"

yt-dlp --write-description --skip-download -o "/opt/yt/downloads/$NOM_VIDEO/description" "$URL"

DATE_LOG=$(date '+%y/%m/%d %H:%M:%S')


echo "[$DATE_LOG] Video $URL was downloaded. File path : /opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4" >> /var/log/yt/do>
                                                                                                  
echo "Video $URL was downloaded."
echo "File path : /opt/yt/downloads/$NOM_VIDEO/$NOM_VIDEO.mp4"
