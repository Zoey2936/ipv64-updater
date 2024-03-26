# ipv64-updater

just use this compose file:

```yaml
services:
  ipv64-updater:
    container_name: ipv64-updater
    image: zoeyvid/ipv64-updater
    restart: always
    network_mode: host                       # you can use bridge if it support IPv6
    environment:
      - "TZ=Europe/Berlin"                     # your timezone
      - "DUK=r23jLIKr6IQwrlU6Wcv4ZxrJePxbd57t" # your Domain Update Token (invalid example)
#      - "UI=5m"                               # interval to update DDNS
#      - "IPv4=true"                           # enable/disable IPv4
#      - "IPv6=true"                           # enable/disable IPv6
```
