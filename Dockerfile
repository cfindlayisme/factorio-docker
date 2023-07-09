# Author: Chuck Findlay <chuck@findlayis.me>
# License: LGPL v3.0
FROM amd64/debian:bookworm-slim AS builder

ARG version="1.1.87"

ADD "https://factorio.com/get-download/${version}/headless/linux64" /tmp/factorio.tar.xz

RUN \
 cd / && \
 apt update && \
 apt install -y xz-utils && \
 tar -xvf /tmp/factorio.tar.xz && \
 chmod +x /factorio/bin/x64/factorio

EXPOSE 34197/udp
VOLUME ["/config"]

FROM amd64/debian:bookworm-slim

COPY --from=builder /factorio /factorio

CMD /factorio/bin/x64/factorio --server-settings /config/server-settings.json --start-server /config/world.zip