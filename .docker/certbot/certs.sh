#!/bin/sh

# Генерирует сертификаты для nginx
# умеет фэйки (Ctrl+C в середине скрипта), staging (--staging параметр), настоящие (запустить без параметров и выполнить до конца скрипт)
# run command to create prod certs
# docker-compose exec certbot /certs.sh kopnik.org [--staging]
# docker-compose exec certbot /certs.sh localhost

domain=$1
mode=$2

echo "domain: $domain"
echo "mode: |$mode|"

if [ -d "/etc/letsencrypt/live/$domain" ]; then
  read -p "Existing data found for $domain. Continue and replace existing certificate? (Y/n) " decision
  if [ "$decision" = "N" ] || [ "$decision" = "n" ]; then
    exit
  fi
fi

if [ ! -e "/etc/letsencrypt/options-ssl-nginx.conf" ] || [ ! -e "/etc/letsencrypt/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "/etc/letsencrypt"
  apk add --update curl && rm -rf /var/cache/apk/*
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf >"/etc/letsencrypt/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem >"/etc/letsencrypt/ssl-dhparams.pem"
  echo
fi

echo "### Creating dummy certificate for $domain ..."
mkdir -p "/etc/letsencrypt/live/$domain"
openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
  -keyout "/etc/letsencrypt/live/$domain/privkey.pem" \
  -out "/etc/letsencrypt/live/$domain/fullchain.pem" \
  -subj "/CN=localhost"
echo

read -p "### Waiting for nginx ...Press Enter when nginx ready. Press Ctrl+ C if you don't want certbot renew certs." decision
echo

echo "### Deleting dummy certificate for $domain ..."
rm -Rf "/etc/letsencrypt/live/$domain"
rm -Rf "/etc/letsencrypt/archive/$domain"
rm -Rf "/etc/letsencrypt/renewal/$domain.conf"
echo

echo "### Requesting Let's Encrypt certificate for $domain ..."
certbot certonly --webroot -w /var/www/certbot $mode --email alexey2baranov@gmail.com -d "$domain" -d "www.$domain" --rsa-key-size 4096 --agree-tos --force-renewal
echo

echo "### Reload nginx by command"
echo "docker-compose exec nginx nginx -s reload"
