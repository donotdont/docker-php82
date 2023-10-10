FROM php:8.2-fpm

ARG env=development

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /var/www

RUN apt-get -y update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
# libssl-dev \
               sudo \
               pkg-config \
               libzip-dev \
               libbz2-dev \
               zip \
               unzip \
               openssl \
               git \
               vim \
               curl \
               libcurl4-openssl-dev \
               libmemcached-dev \
               libz-dev \
               libpq-dev \
               libpng-dev \
               libjpeg-dev \
#               libjpeg-turbo-dev \
               libfreetype6-dev \
               libssl-dev \
#               libjson-c-dev \
               libwebp-dev \
               libmcrypt-dev \
               libonig-dev \
               libxml2-dev \
               libxpm-dev;
#     rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
#    && docker-php-ext-install bz2 \
#    && docker-php-ext-install curl \
#    && docker-php-ext-install dom \
#    && docker-php-ext-install fileinfo \
#    && docker-php-ext-install iconv \
    && docker-php-ext-configure gd \
            --prefix=/usr \
            --with-jpeg \
            --with-webp \
            --with-xpm \
            --with-freetype \
    && docker-php-ext-install -j "$(nproc)" \
        bz2 \
        curl \
        dom \
        fileinfo \
        gd \
        iconv \
        intl \
#        json_post \
#        jsonpath \
        mbstring \
#        openssl \
#        xml \
#        mysqli \
#        opcache \
        zip \
#        bcmath \
    ;
#    && docker-php-ext-install pdo_mysqli
#    && docker-php-ext-install gd


RUN pecl install zlib zip mysqli \
    && docker-php-ext-enable zip \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable pdo \
    && docker-php-ext-enable pdo_mysql \
#    && docker-php-ext-enable pdo_mysqli
    && docker-php-ext-enable curl \
    && docker-php-ext-enable dom \
    && docker-php-ext-enable fileinfo \
    && docker-php-ext-enable gd \
    && docker-php-ext-enable iconv \
    && docker-php-ext-enable intl \
#    && docker-php-ext-enable json_post \
#    && docker-php-ext-enable jsonpath \
    && docker-php-ext-enable mbstring \
#    && docker-php-ext-enable openssl \
#    && docker-php-ext-enable xml \
     ;

#    && docker-php-ext-enable -j "$(nproc)" \
#        bz2 \
#        gd \
#        mysqli \
#        opcache \
#        zip \
#        bcmath \
#    ;


#RUN addgroup -g 1000 -S www-data \
#    && adduser -u 1000 -S ubuntu -G www-data

#RUN addgroup --system www-data && adduser --system --group ubuntu
#USER ubuntu

#RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN cp "$PHP_INI_DIR/php.ini-$env" "$PHP_INI_DIR/php.ini"; \
    sed -i -e 's/^ *post_max_size.*/post_max_size = 32M/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/^ *upload_max_filesize.*/upload_max_filesize = 128M/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/^ *memory_limit.*/memmory_limit = 512M/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/^ *max_input_time.*/max_input_time = 360000/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/^ *max_execution_time.*/max_execution_time = 360000/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/^ *whatever_option.*/whatever_option = 4321/g' /usr/local/etc/php/php.ini \
    ;

#RUN chown -R ubuntu:www-data /usr/local/etc/php/php.ini
#RUN chmod -R 775 /usr/local/etc/php/php.ini

#RUN sed -i -e 's/^ *post_max_size.*/post_max_size = 32M/g' "$PHP_INI_DIR/php.ini-$env" && \
#    sed -i -e 's/^ *upload_max_filesize.*/upload_max_filesize = 128M/g' "$PHP_INI_DIR/php.ini-$env" && \
#    sed -i -e 's/^ *memory_limit.*/memmory_limit = 512M/g' "$PHP_INI_DIR/php.ini-$env" && \
#    sed -i -e 's/^ *max_input_time.*/max_input_time = 360000/g' "$PHP_INI_DIR/php.ini-$env" && \
#    sed -i -e 's/^ *max_execution_time.*/max_execution_time = 360000/g' "$PHP_INI_DIR/php.ini-$env" && \
#    sed -i -e 's/^ *whatever_option.*/whatever_option = 4321/g' "$PHP_INI_DIR/php.ini-$env" \
#    ;

RUN printf 'post_max_size = 32M \n\
upload_max_filesize = 128M \n\
memory_limit = 2048M \n\
max_input_time = 360000 \n\
max_execution_time = 360000 \n\
whatever_option = 4321' >> /usr/local/etc/php/conf.d/docker-php.ini;


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000