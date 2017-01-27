#!/bin/bash
cp squid.conf.${AUTH} /etc/squid/squid.conf
/etc/init.d/squid start
sleep ${WAIT_S}
tail -f /var/log/squid/access.log
