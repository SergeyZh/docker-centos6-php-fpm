FROM sergeyzh/centos6-epel

MAINTAINER Sergey Zhukov, sergey@jetbrains.com

ADD rpms/ /root/rpms/
RUN yum localinstall -y /root/rpms/*.rpm ; rm -rf /root/rpms

RUN touch /etc/sysconfig/network
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php-fpm.d/www.conf
RUN sed -i '/^listen.allowed_clients/ s/^/;/' /etc/php-fpm.d/www.conf

ADD run-services.sh /
RUN chmod a+x /run-services.sh
CMD /run-services.sh

EXPOSE 9000
