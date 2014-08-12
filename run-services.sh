#!/bin/sh

modify_php_ini()
{
    echo "PHP Param: $1"
    NAME=`echo $1 | cut -d '=' -f 1`
    VALUE=`echo $1 | cut -d '=' -f 2`
    sed -i "/^${NAME}/ s/${NAME}.*/${NAME}\ =\ ${VALUE}/" /etc/php.ini
    if [ -z "`grep -E ^${NAME} /etc/php.ini`" ] ; then 
	echo "${NAME} = ${VALUE}" >> /etc/php.ini
	echo "Added"
    fi
}


touch /var/log/php-fpm/www-error.log


if [ ! -z "${PHP_FPM_USER}" ] ; then
    sed -i "/^user =/ s/.*/user = ${PHP_FPM_USER}/" /etc/php-fpm.d/www.conf
    chown ${PHP_FPM_USER} /var/log/php-fpm/www-error.log 
    chown -R ${PHP_FPM_USER} /var/lib/php/session
fi

ARRAY_PHP=`set | grep -E ^PHPINI_`
if [ ! -z "${ARRAY_PHP}" ] ; then
    ARRAY_PHP=`echo ${ARRAY_PHP} | sed s/PHPINI_//g | sed s/__/./g`
    for PARAM in ${ARRAY_PHP} ; do
	modify_php_ini ${PARAM}
    done
    
fi

shutdown_php_fpm()
{
    echo "Stopping container..."
    /sbin/service php-fpm stop
    killall reloader.sh
    killall etcdctl
    exit 0
}

trap shutdown_php_fpm SIGINT SIGTERM SIGHUP

/sbin/service php-fpm start

tail -f /var/log/php-fpm/www-error.log &

if [ ! -z "${ETCD_PEER}" ] ; then
    /reloader.sh ${ETCD_PEER} ${ETCD_WATCH} &
fi

wait

