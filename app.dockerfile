FROM php:7.2-fpm

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="1" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

RUN apt-get update \
    && apt-get install -y cron \
    supervisor \
    vim-tiny \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd \
    && apt-get install -y libmcrypt-dev \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
    && apt-get install -y mysql-client \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-enable opcache \
    && docker-php-ext-install calendar

COPY docker/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

RUN echo "realpath_cache_size = 4096k; realpath_cache_ttl = 7200;" > /usr/local/etc/php/conf.d/php.ini

RUN apt-get install -y \
    git \
    vim-tiny \
    openssh-client \
    sudo 

RUN mkdir -p /root/.ssh
ADD .ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

RUN mkdir -p /var/www/.ssh
ADD .ssh/id_rsa /var/www/.ssh/id_rsa
RUN chmod 700 /var/www/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /var/www/.ssh/config

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

WORKDIR /var/www/html