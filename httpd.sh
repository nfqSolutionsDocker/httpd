#!/bin/sh

set -e

/solutions/install_packages.sh

echo Configurando httpd ...
if [ ! -z $USER ]; then
	if [ ! -z $PASSWORD ]; then
		htpasswd -b /etc/httpd/pwd/password ${USER} ${PASSWORD}
		sed -i -e 's/*USER/'${USER}'/g' /etc/httpd/conf/httpd.conf
	else
		echo "Falta password del usuario"
		echo "Añada la variable PASSWORD al arranque del contenedor"
	fi
fi

# Apache gets grumpy about PID files pre-existing
rm -f /run/httpd/httpd.pid

exec httpd -DFOREGROUND