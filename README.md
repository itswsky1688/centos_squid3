## Name
centos_squid3

## Overview

## Description

## Demo

## Requirement

## Usage
docker build -t squid:1.0 .  
docker run -it --name squid squid:1.0 bash  
scp /etc/squid/squid.conf sts@172.17.0.1:.  
docker run -it --name squid -p 3128:3128 -v `pwd`/squid.conf:/etc/squid/squid.conf squid:1.0  
htpasswd -c /etc/squid/squid-passwd testuser  
squid.conf  
auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/squid-passwd  
auth_param basic children 5  
auth_param basic realm Http Basic Auth !  
auth_param basic credentialsttl 2 hours  
acl password proxy_auth REQUIRED  
http_access allow password  

## Install

## Contribution

## Licence

[MIT]

## Author

[itswsky1688]


