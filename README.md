### httpd

This container has the following characteristics:
- Container nfqsolutions/centos:7.
- Installations script of httpd in centos. This script create access user to httpd. This script is executing in the next containers or in the docker compose.

For example, docker-compose.yml:
```
app:
 image: nfqsolutions/httpd
 restart: always
 ports:
  - "80:8080"
 environment:
  - PACKAGES=
  - USER=solutions
  - PASSWORD=solutions
 volumes:
  - <mydirectory>:/var/www/html
 
```