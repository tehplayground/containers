FROM php:8.0.13
RUN \
  apt-get update && apt-get install -y libcurl4-openssl-dev libbz2-dev libxml2-dev libenchant-2-dev libssl-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libgmp-dev libc-client-dev libkrb5-dev libicu-dev libldap2-dev libldap-2.4-2 libmcrypt-dev libpq-dev libsqlite3-dev libpspell-dev libedit-dev librecode-dev libtidy-dev libxslt-dev libzip-dev && \
  docker-php-ext-configure gd --with-freetype --with-jpeg && \
  docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
  docker-php-ext-install -j$(nproc) bz2 bcmath calendar dba dom enchant exif ftp gd gettext gmp imap intl ldap mysqli opcache pcntl pdo pdo_mysql pdo_pgsql pgsql pspell shmop simplexml soap sockets sysvmsg sysvsem sysvshm tidy xsl zip
RUN ln -s /usr/local/bin/php /php

ADD common/run.sh /run.sh
ADD common/content /content
RUN useradd -d /render -m -s /bin/false -U render
USER render
WORKDIR /render
ENTRYPOINT ["/run.sh"]
