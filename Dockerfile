FROM nfqsolutions/centos:7

MAINTAINER solutions@nfq.com

# Instalacion
RUN yum -y update && \
	yum -y install httpd
	
# Modificaciones para SOLUTIONS
RUN sed -i -e 's/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks\n        IndexOptions FancyIndexing NameWidth=*\n        AddIcon \/usr\/share\/httpd\/icons\/text.png .log\n        AddIcon \/usr\/share\/httpd\/icons\/dir.png \^\^DIRECTORY\^\^/g' /etc/httpd/conf/httpd.conf && \
	sed -i -e ':a;N;$!ba;s/Require all granted/#Require all granted\n    Order allow,deny\n    Allow from all\n        AuthType Basic\n        AuthName \"Restricted Files\"\n        AuthBasicProvider file\n        AuthUserFile \"\/etc\/httpd\/pwd\/password\"\n        Require user *USER\n/2' /etc/httpd/conf/httpd.conf && \
	echo "" >> /etc/httpd/conf/httpd.conf && \
	echo "<Directory \"/usr/share/httpd/icons\">" >> /etc/httpd/conf/httpd.conf && \
	echo "    Options Indexes FollowSymLinks" >> /etc/httpd/conf/httpd.conf && \
	echo "    AllowOverride None" >> /etc/httpd/conf/httpd.conf && \
	echo "    Order allow,deny" >> /etc/httpd/conf/httpd.conf && \
	echo "    Allow from all" >> /etc/httpd/conf/httpd.conf && \
	echo "</Directory>" >> /etc/httpd/conf/httpd.conf && \
	mkdir /etc/httpd/pwd && \
	echo "" > /etc/httpd/pwd/password

# Script de arranque
COPY httpd.sh /etc/httpd/
RUN chmod 777 /etc/httpd/httpd.sh && \
	chmod a+x /etc/httpd/httpd.sh && \
	sed -i -e 's/\r$//' /etc/httpd/httpd.sh
	
# Volumen para el httpd
VOLUMEN /var/www/html

# Puertos de salida del httpd
EXPOSE 80

# Copy supervisor file
COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]