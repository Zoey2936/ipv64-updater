# syntax=docker/dockerfile:labs
FROM alpine:3.21.2
COPY update.sh /usr/local/bin/update.sh
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN apk upgrade --no-cache -a && \
    apk add --no-cache ca-certificates tzdata tini curl jq bind-tools && \
    chmod -R 777 /tmp

ENV IPv4=true \
    IPv6=true \
    UI=5m

USER nobody
ENTRYPOINT ["tini", "--", "update.sh"]
HEALTHCHECK CMD healthcheck.sh || exit 1
