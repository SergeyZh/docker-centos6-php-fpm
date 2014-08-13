#!/bin/sh

#if [ -z "$1" ] ; then
#    echo "Usage: $0 <etcd_peer> [<etcd_path_to_watch>]"
#    exit 1
#fi

ETCDCTL_WATCH=/services/phpfpm/reload
if [ ! -z "$1" ] ; then
    ETCDCTL_WATCH=$1
fi

while true ; do
    RESULT=`etcdctl watch ${ETCDCTL_WATCH}`
    
    if [ "${RESULT}" == "reload" ] ; then
	echo "Catched reload action. Reloading..."
	cp -f /conf/phpfpm/php.ini /etc/php.ini
	/sbin/service php-fpm reload
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done