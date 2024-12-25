#!/bin/sh

if [ -z "$TZ" ] || ! echo "$TZ" | grep -q "^[A-Za-z/]\+$"; then
    echo "TZ is unset or invalid."
    sleep inf
fi

if ! echo "$UI" | grep -q "^[0-9]\+[smhd]\?$"; then
    echo "UI needs to be a number which can be followed by one of the chars s, m, h or d."
    sleep inf
fi

if [ -z "$DUK" ] || ! echo "$DUK" | grep -q "^[A-Za-z0-9]\+$"; then
    echo "DUK is unset or invalid, it can consist of 32 of the following characters, upper letters A-Z, lower letters a-z and numbers 0-9."
    sleep inf
fi

if [ -z "$DUDs" ] || ! echo "$DUDs" | grep -q "\."; then
    echo "DUDs is unset or invalid, it needs to contain at least one dot."
    sleep inf
fi

if ! echo "$IPv4" | grep -q "^true$\|^false$"; then
    echo "IPv4 needs to be true or false."
    sleep inf
fi

if ! echo "$IPv6" | grep -q "^true$\|^false$"; then
    echo "IPv6 needs to be true or false."
    sleep inf
fi

if ! curl -sS4 ipv4.ipv64.net -o /dev/null; then
    echo "IPv4 does not work, disabling it."
    export IPv4="false"
fi

if ! curl -sS6 ipv6.ipv64.net -o /dev/null; then
    echo "IPv6 does not work, disabling it."
    export IPv6="false"
fi


if [ "$IPv4" = "false" ] && [ "$IPv6" = "false" ]; then
    echo "IPv4 and IPv6 disabled, stopping."
    sleep inf
fi

while true; do
  for DUD in $DUDs; do
    if [ "$IPv4" = "true" ] && [ "$(curl -sS4 https://ipv4.ipv64.net/ipcheck.php?ipv4)" != "$(dig "$DUD" IN A +short +https +tls-ca=/etc/ssl/certs/ca-certificates.crt @1.1.1.1 | grep '^[0-9.]\+$' | sort | head -n1)" ]; then
        curl -sSL4 "https://ipv4.ipv64.net/update.php?key=$DUK&domain=$DUD" | tee /tmp/IPv4.json
    fi
    if [ "$IPv6" = "true" ] && [ "$(curl -sS6 https://ipv6.ipv64.net/ipcheck.php?ipv6)" != "$(dig "$DUD" IN AAAA +short +https +tls-ca=/etc/ssl/certs/ca-certificates.crt @1.1.1.1 | grep '^[0-9a-f:]\+$' | sort | head -n1)" ]; then
        curl -sSL6 "https://ipv6.ipv64.net/update.php?key=$DUK&domain=$DUD" | tee /tmp/IPv6.json
    fi
  done

  sleep "$UI"
done
