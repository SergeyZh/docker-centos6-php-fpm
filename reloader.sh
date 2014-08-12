#!/bin/sh

if [ -z "$1" ] ; then
    echo "Usage: $0 <etcd_peer> [<etcd_path_to_watch>]"
    exit 1
fi

ETCD_WATCH=/services/phpfpm/reload
if [ ! -z "$2" ] ; then
    ETCD_WATCH=$2
fi

while true ; do
    RESULT=`etcdctl -peers $1 watch ${ETCD_WATCH}`
    
    if [ "${RESULT}" == "reload" ] ; then
	echo "Catched reload action. Reloading..."
	cp -f /conf/phpfpm/php.ini /etc/php.ini
	/sbin/service php-fpm reload
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done