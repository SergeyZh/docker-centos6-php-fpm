docker-centos6-php-fpm
======================

CentOS6 + php-fpm daemon

This container is intended to be a FCGI daemon to serve requests to PHP files. 
With additional configuration (see below) it can reload configuration on the fly with no interruption of service.

### List of environment variables

* `PHP_FPM_USER` - the user id to run PHP-FPM daemon. Optional.
* `PHPINI_xxxxx` - set of variables to modify php.ini. Optional.
* `ETCD_PEER` - address of etcd service to watch reload signal. Optional.
* `ETCD_WATCH` - path inside etcd to watch reload signal. Optional.

### Usage

Use -e PHP_FPM_USER=<user id> to run php-fpm under other Unix account. 
It may be necessary to access PHP files.

You may set variables like `PHPINI_XXXX=Value` to set variable `XXXX = Value` at `/etc/php.ini` file.
For example `-e PHPINI_upload_max_filesize=5M` will set upload_max_filesize = 5M at php.ini.

If you need to set variable with dot `.` inside, you may use double underscore `__`.
For example `-e PHPINI_soap__wsdl_cache_enabled=1` will set soap.wsdl_cache_enabled = 1 at php.ini.

### Reload configuration on the fly

New configuration files should be at `/conf/phpfpm/` directory then you need to send `reload` string to `ETCD_WATCH` path to initiate reload of PHP-FPM.
You may use [`varsy/configurator`](https://registry.hub.docker.com/u/varsy/configurator/) container to manage git based configuration and reload PHP-FPM daemon.
Use templates of configuration from `confd` directory.
