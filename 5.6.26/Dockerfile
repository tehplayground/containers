FROM php:5.6.26-cli
RUN ln -s /usr/local/bin/php /php

ADD common/run.sh /run.sh
ADD common/content /content
RUN useradd -d /render -m -s /bin/false -U render
USER render
WORKDIR /render
ENTRYPOINT ["/run.sh"]
