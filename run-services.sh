#!/bin/sh

touch /var/log/php-fpm/www-error.log


if [ ! -z "${PHP_FPM_USER}" ] ; then
    sed -i "/^user =/ s/.*/user = ${PHP_FPM_USER}/" /etc/php-fpm.d/www.conf
    chown ${PHP_FPM_USER} /var/log/php-fpm/www-error.log 
    chown -R ${PHP_FPM_USER} /var/lib/php/session
fi

shutdown_php_fpm()
{
    echo "Stopping container..."
    /sbin/service php-fpm stop
    exit 0
}

trap shutdown_php_fpm SIGINT SIGTERM SIGHUP

/sbin/service php-fpm start

tail -f /var/log/php-fpm/www-error.log &

wait
