This is a simple docker image for a vanilla factorio server.

You simply need to mount the volume /config and put two files in it:
- world.zip
- server-settings.json

It was written with cloud providers in mind to save me time deploying a server each time I decide to play a bit.