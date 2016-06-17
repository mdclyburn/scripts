#!/bin/sh

set -u
set -e

SERVER=$1
SOURCE_DIR="/usr/local/etc/letsencrypt.sh/certs"
DEST_DIR="/usr/local/etc/nginx/ssl"

# Move certificate to appropriate directory.
cp -L ${SOURCE_DIR}/${SERVER}/fullchain.pem ${DEST_DIR}/${SERVER}_cert.pem
cp -L ${SOURCE_DIR}/${SERVER}/privkey.pem ${DEST_DIR}/${SERVER}_key.pem

# Set ownership and permissions securely.
chmod 0440 ${DEST_DIR}/${SERVER}_cert.pem ${DEST_DIR}/${SERVER}_key.pem
chown root:www ${DEST_DIR}/${SERVER}_cert.pem ${DEST_DIR}/${SERVER}_key.pem

printf "Deployed certificate for %s.\n" "${SERVER}"

exit 0
