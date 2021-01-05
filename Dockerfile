FROM amd64/debian:buster-slim

ARG version="1.0.0"
ARG USER=factorio
ARG GROUP=factorio
ARG PUID=845
ARG PGID=845

ADD "https://factorio.com/get-download/${version}/headless/linux64" /tmp/factorio.tar.xz

RUN \
 echo "**** Install factorio ****" && \
 cd / && \
 apt-get update && apt-get install xz-utils && \
 tar -xvf /tmp/factorio.tar.xz && \
 chmod +x /factorio/bin/x64/factorio && \
 echo "**** Create user ****" && \
 mkdir /config && \
 addgroup --gid "$PGID" "$GROUP" && \
 adduser --home /config --system --uid "$PUID" --ingroup "$GROUP" --shell /bin/sh "$USER" && \
 chown -R ${USER}:${GROUP} /config /factorio && \
 echo "**** Cleanup ****" && \
 rm -rf \
	/tmp/* 

EXPOSE 34197/udp
VOLUME ["/config"]

USER ${USER}

CMD /factorio/bin/x64/factorio --server-settings /config/server-settings.json --start-server /config/world.zip