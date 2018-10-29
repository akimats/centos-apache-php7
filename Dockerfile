FROM centos
MAINTAINER Clarence Ho<clarence@skywidesoft.com>

# Install Apache and PHP packages
RUN yum upgrade -y \
    && yum install -y httpd \
    && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
    && yum install -y php72w php72w-opcache php72w-gd php72w-imap php72w-intl php72w-mbstring php72w-mcrypt php72w-mysql php72w-pear cc gcc make php72w-devel mysql less \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && sed 's/memory_limit = 128M/memory_limit = 512M/' /etc/php.ini > /tmp/php.ini \
    && mv -f /tmp/php.ini /etc/php.ini \
    && pecl install xdebug

COPY httpd.conf /etc/httpd/conf
COPY xdebug.ini /etc/php.d/xdebug.ini

# Start Apache
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
