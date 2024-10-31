# Author: Chuck Findlay <chuck@findlayis.me>
# License: LGPL v3.0
FROM amd64/debian:bookworm-slim AS builder

ARG version="2.0.12"

ADD "https://factorio.com/get-download/${version}/headless/linux64" /tmp/factorio.tar.xz

WORKDIR /
RUN \
 apt-get update && \
 apt-get install -y xz-utils=5.4.1-0.2 && \
 tar -xvf /tmp/factorio.tar.xz && \
 chmod +x /factorio/bin/x64/factorio && \
 rm -rf /var/lib/apt/lists/*

EXPOSE 34197/udp
VOLUME ["/config"]

FROM amd64/debian:bookworm-slim

COPY --from=builder /factorio /factorio

CMD ["bash", "-c", "/factorio/bin/x64/factorio --server-settings /config/server-settings.json --start-server /config/world.zip"]