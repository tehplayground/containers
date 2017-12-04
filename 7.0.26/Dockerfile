FROM php:7.0.26
RUN \
  apt-get update && apt-get install -y libcurl4-openssl-dev libbz2-dev libxml2-dev libenchant-dev libssl-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libgmp-dev libc-client-dev libkrb5-dev libicu-dev libldap2-dev libldap-2.4-2 libmcrypt-dev libpq-dev libsqlite3-dev libpspell-dev libedit-dev librecode-dev libtidy-dev libxslt-dev && \
  docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir && \
  docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
  CFLAGS="-I/usr/src/php" docker-php-ext-configure xmlreader && \
  docker-php-ext-install -j$(nproc) bz2 bcmath calendar ctype curl dba dom enchant exif ftp gd gettext gmp hash iconv imap intl json ldap mbstring mcrypt mysqli opcache pcntl pdo pdo_mysql pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode session shmop simplexml soap sockets sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip
RUN ln -s /usr/local/bin/php /php

ADD common/run.sh /run.sh
ADD common/content /content
RUN useradd -d /render -m -s /bin/false -U render
USER render
WORKDIR /render
ENTRYPOINT ["/run.sh"]
