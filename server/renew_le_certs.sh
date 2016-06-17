#!/bin/sh

set -u
set -e

DEPLOY_SCRIPT="/usr/local/bin/deploy_le_cert.sh"

# Renew certificates.
letsencrypt.sh -c
if [ $? != "0" ]
then
	printf "Certificate renewal failed. Not continuing to deployment.\n"
	exit 1
else
	printf "Finished certificate renewal. Deploying...\n"
fi

# Deploy each domain renewed.
for domain in $(cat /usr/local/etc/letsencrypt.sh/domains.txt)
do
	${DEPLOY_SCRIPT} $domain
done

# Restart NGINX.
service nginx restart

exit 0
