# Author: Chuck Findlay <chuck@findlayis.me>
# License: LGPL v3.0
FROM amd64/debian:bookworm-slim

ARG version="1.1.87"

ADD "https://factorio.com/get-download/${version}/headless/linux64" /tmp/factorio.tar.xz

RUN \
 echo "**** Install factorio ****" && \
 cd / && \
 apt update && \
 apt install -y xz-utils && \
 tar -xvf /tmp/factorio.tar.xz && \
 chmod +x /factorio/bin/x64/factorio && \
 echo "**** Cleanup ****" && \
 apt remove -y xz-utils && \
 apt clean && \
 rm -rf \
	/tmp/* 

EXPOSE 34197/udp
VOLUME ["/config"]

CMD /factorio/bin/x64/factorio --server-settings /config/server-settings.json --start-server /config/world.zip