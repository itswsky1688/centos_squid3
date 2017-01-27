# docker build -t squid:1.0 .
# docker run -it --name squid squid:1.0 bash 
# scp /etc/squid/squid.conf sts@172.17.0.1:.
# docker run -it --name squid -p 3128:3128 -v `pwd`/squid.conf:/etc/squid/squid.conf squid:1.0
#
# htpasswd -c /etc/squid/squid-passwd testuser
# squid.conf
# auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/squid-passwd
# auth_param basic children 5
# auth_param basic realm Http Basic Auth !
# auth_param basic credentialsttl 2 hours
# acl password proxy_auth REQUIRED
# http_access allow password

FROM centos:centos6

RUN yum -y update
RUN yum -y install vim wget curl unzip zip
RUN yum -y install squid krb5-workstation samba-common ntp samba-winbind authconfig
RUN yum -y install httpd-tools

EXPOSE 3128

ENV WAIT_S=3

WORKDIR /app
RUN echo "#!/bin/bash \n\
/etc/init.d/squid start \n\
sleep ${WAIT_S} \n\
tail -f /var/log/squid/access.log \n\
" >> startup.sh
RUN chmod +x startup.sh
CMD "/app/startup.sh"

RUN htpasswd -c -b /etc/squid/squid-passwd user0001 password

