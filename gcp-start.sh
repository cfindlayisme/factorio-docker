#!/bin/bash
#
# Start script handler for GCP factorio-docker image
#
# Author: Chuck Findlay <chuck@findlayis.me>
# License: LGPL v3.0

echo "0 */1 * * * gcloud auth activate-service-account --key-file=/config/gcs-key.json && gsutil cp /config/world.zip gs://$GCS_BUCKET$GCS_BUCKET_PATH/world.zip" > /etc/cron.d/gcs-hourly-backup
chmod 0644 /etc/cron.d/gcs-hourly-backup
crontab /etc/cron.d/gcs-hourly-backup

# Start cron so it runs auto backups
cron

# Check for service account key
if [ ! -f /config/gcs-key.json ]; then
    echo "No gcs-key.json file present for the GCS service account. Exiting!"
    exit 1
fi

# Authenticate to GCS
gcloud auth activate-service-account --key-file=/config/gcs-key.json

# Check for server settings - and exit if we cannot get it
if [ ! -f /config/server-settings.json ]; then
    if gsutil cp gs://$GCS_BUCKET$GCS_BUCKET_PATH/server-settings.json /config/server-settings.json; then
        echo "Grabbed server-settings.json from GCS bucket since it did not exist locally!"
    else
        echo "No server-settings.json file present here or in cloud bucket. Exiting!"
        exit 1
    fi
fi

# Check for world
if [ ! -f /config/world.zip ]; then
    if gsutil cp gs://$GCS_BUCKET$GCS_BUCKET_PATH/world.zip /config/world.zip; then
        echo "Grabbed world.zip from GCS bucket since it did not exist locally!"
    else
        echo "world.zip does not exist locally or in the bucket. One is needed for factorio, so exiting!"
        exit 1
    fi
fi

# Start terrara
if /factorio/bin/x64/factorio --server-settings /config/server-settings.json --start-server /config/world.zip --rcon-port $RCON_PORT --rcon-password "$RCON_PASSWORD"; then
    # Copy over to GCS once done
    gsutil cp /config/world.zip gs://$GCS_BUCKET$GCS_BUCKET_PATH/world.zip
    gsutil cp /config/server-settings.json gs://$GCS_BUCKET$GCS_BUCKET_PATH/server-settings.json
    echo "Server exited gracefully. Copied world.zip and server-settings.json to GCS bucket"
else
    echo "Server exited non-gracefully - not copying the world and server config to the GCP bucket"
fi