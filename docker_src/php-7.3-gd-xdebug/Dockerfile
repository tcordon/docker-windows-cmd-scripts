FROM php:7.3

#Installa Xdebu
RUN pecl install xdebug-beta

#Install int (internationalizacion)
RUN apt-get update && apt-get install -y g++ libicu-dev && docker-php-ext-install -j$(nproc) intl

#Enable PHP Extension
RUN docker-php-ext-enable xdebug

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \ 
    && docker-php-ext-install gettext
