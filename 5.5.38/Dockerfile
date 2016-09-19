FROM ubuntu:14.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get build-dep -y php5 curl && \
  apt-get install -y wget curl libc-client-dev libmcrypt-dev

RUN \
  wget http://php.net/distributions/php-5.5.38.tar.bz2 && \
  tar -xjf php-5.5.38.tar.bz2 && \
  cd php-5.5.38 && \
  ./configure --disable-rpath --enable-bcmath --enable-calendar --enable-exif --enable-ftp --enable-gd-native-ttf --enable-inline-optimization --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-soap --enable-sockets --enable-sysvsem --enable-sysvshm --enable-zip --prefix=/usr --with-bz2 --with-config-file-path=/etc/php5 --with-curl --with-freetype-dir --with-gd --with-gettext --with-imap --with-imap-ssl --with-jpeg-dir --with-kerberos --with-libxml-dir=/usr --with-mcrypt --with-mhash --with-mysql --with-mysqli --with-openssl --with-pcre-regex --with-pear=/usr/share/php --with-png-dir=/usr --with-regex=php --with-xmlrpc --with-zlib --with-zlib-dir && \
  make -j `nproc` && \
  make install && \
  ln -s /usr/bin/php /php && \
  rm -rf /php-5.5.38*

ADD common/run.sh /run.sh
ADD common/content /content
RUN useradd -d /render -m -s /bin/false -U render
USER render
WORKDIR /render
ENTRYPOINT ["/run.sh"]
