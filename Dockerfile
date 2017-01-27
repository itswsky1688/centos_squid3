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

