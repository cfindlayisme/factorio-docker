This repo contains two docker images for factorio. One is a simple vanlla image, and the other contains a backup script that will backup the config and world regularly to a GCP bucket. Overall cost works to pennies per month CAD.

## Vanilla (Dockerfile)
Mount the folder /config and put these two folders in it:
- world.zip
- server-settings.json

Forward ports 34197 UDP

And run it.
`docker run -p 34197:34197/udp -v /path/to/config:/config gitea.findlayis.me/chuck/factorio-docker:latest`

## GCP Image (Dockerfile-GCP)
Same as vanilla, but also set the following env variables:
- GCS_BUCKET
- GCS_BUCKET_PATH
- RCON_PORT
- RCON_PASSWORD

And add gcs-key.json (key from Google Cloud Platform) to /config with access to write to the desired bucket. Backup will run every six hours, or on clean shutdown of the server.

Forward $RCON_PORT (TCP) for RCON access.

See docker-compose.yaml.sample for an example of this one in compose format.

## Updating
Change `ARG version="1.1.94"` in Dockerfile to the desired version, and then build.

## Building
Built via Github Actions, but can be built locally with 
`docker build -t gitea.findlayis.me/chuck/factorio-docker:latest .` 
and then 
`docker build -t gitea.findlayis.me/chuck/factorio-docker-gcp:latest -f Dockerfile-GCP .`

GCP image builds off the vanilla as base so vanilla needs to be built first.

Github Actions builds and pushes to my private registry, and deploys my server for me via a simple `docker-compose up -d` command setup via ansible.