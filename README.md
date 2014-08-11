docker-centos6-php-fpm
======================

CentOS6 + php-fpm daemon

Use -e PHP_FPM_USER=<user id> to run php-fpm under other Unix account. 
It may be necessary to access PHP files.

You may set variables like `PHPINI_XXXX=Value` to set variable `XXXX = Value` at `/etc/php.ini` file.
For example `-e PHPINI_upload_max_filesize=5M` will set upload_max_filesize = 5M at php.ini.

If you need to set variable with dot `.` inside, you may use double underscore `__`.
For example `-e PHPINI_soap__wsdl_cache_enabled=1` will set soap.wsdl_cache_enabled = 1 at php.ini.

