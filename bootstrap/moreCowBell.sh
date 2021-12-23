#!/bin/sh
set -eux

readonly DATA_DIR="/bootstrap/data"
readonly CONFIG_DIR="/bootstrap/config"

readonly LDAP_DOMAIN=planetexpress.com
readonly LDAP_ORGANISATION="Planet Express, Inc."
readonly LDAP_BINDDN="cn=admin,dc=planetexpress,dc=com"
readonly LDAP_SECRET=GoodNewsEveryone

readonly LDAP_SSL_KEY="/etc/ldap/ssl/ldap.key"
readonly LDAP_SSL_CERT="/etc/ldap/ssl/ldap.crt"


echo "Load more groups..."
for index  in `seq 1 1100`
do
	cat > /tmp/new << EOF
dn: cn=admin_staff_xx${index},ou=people,dc=planetexpress,dc=com
objectclass: Group
objectclass: top
groupType: 2147483650
cn: admin_staff_xx${index}
member: cn=Hubert J. Farnsworth,ou=people,dc=planetexpress,dc=com
EOF
	echo "Processing file /tmp/new..."
	ldapadd -x -H ldapi:/// \
		-D ${LDAP_BINDDN} \
		-w ${LDAP_SECRET} \
		-f /tmp/new
	rm -f /tmp/new
done
