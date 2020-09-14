#!/bin/sh
/usr/sbin/sshd
/usr/sbin/nginx -g 'daemon off;' 
tail -f /dev/null
