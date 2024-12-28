
#!/bin/bash

# File containing YouTube URLs
URL_FILE="/opt/yt/yt_urls.txt"
LOG_FILE="/var/log/yt/download.log"
DOWNLOAD_DIR="/opt/yt/downloads/"

# Check if URL_FILE exists, if not, create it
if [[ ! -f "$URL_FILE" ]]; then
    touch "$URL_FILE"
    echo "[$(date +"%y/%m/%d %H:%M:%S")] URL file $URL_FILE was created because it did not exist." >> $LOG_FILE
fi

while IFS= read -r line
do
    # Check if URL is valid YouTube URL
    if [[ $line =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/.*$ ]]; then
        # Get video title to use as directory name
        TITLE=$(yt-dlp --get-title "$line" 2>/dev/null)

        # Create directory for the video
        mkdir -p "$DOWNLOAD_DIR/$TITLE"

        # Download video and description
        yt-dlp -o "$DOWNLOAD_DIR/$TITLE/$TITLE.mp4" --write-description "$line" > /dev/null 2>&1

        # Check if download was successful
        if [[ -f "$DOWNLOAD_DIR/$TITLE/$TITLE.mp4" ]]; then
            # Log the download
            echo "[$(date +"%y/%m/%d %H:%M:%S")] Video $line was downloaded. File path : $DOWNLOAD_DIR$TITLE/$TITLE.mp4" >> $LOG_FILE
        else
            echo "[$(date +"%y/%m/%d %H:%M:%S")] Failed to download video from $line" >> $LOG_FILE
        fi
    else
        echo "[$(date +"%y/%m/%d %H:%M:%S")] Invalid URL: $line" >> $LOG_FILE
    fi
    # Remove the processed line from the file
    sed -i '1d' $URL_FILE
done < $URL_FILE
