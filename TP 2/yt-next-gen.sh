
#!/bin/bash


URL_FILE="/opt/yt/yt_urls.txt"
LOG_FILE="/var/log/yt/download.log"
DOWNLOAD_DIR="/opt/yt/downloads/"

if [[ ! -f "$URL_FILE" ]]; then
    touch "$URL_FILE"
    echo "[$(date +"%y/%m/%d %H:%M:%S")] URL file $URL_FILE was created because it did not exist." >> $LOG_FILE
fi

while IFS= read -r line
do
    if [[ $line =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/.*$ ]]; then
     
        TITLE=$(yt-dlp --get-title "$line" 2>/dev/null)

        mkdir -p "$DOWNLOAD_DIR/$TITLE"
        
        yt-dlp -o "$DOWNLOAD_DIR/$TITLE/$TITLE.mp4" --write-description "$line" > /dev/null 2>&1
        
        if [[ -f "$DOWNLOAD_DIR/$TITLE/$TITLE.mp4" ]]; then
          
            echo "[$(date +"%y/%m/%d %H:%M:%S")] Video $line was downloaded. File path : $DOWNLOAD_DIR$TITLE/$TITLE.mp4" >> $LOG_FILE
        else
            echo "[$(date +"%y/%m/%d %H:%M:%S")] Failed to download video from $line" >> $LOG_FILE
        fi
    else
        echo "[$(date +"%y/%m/%d %H:%M:%S")] Invalid URL: $line" >> $LOG_FILE
    fi
    
    sed -i '1d' $URL_FILE
done < $URL_FILE
