FROM php:5.6-cli

#Install Memcached
RUN apt-get update && apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

#Install Redis PHP Extension
RUN apt-get update \
	&& pecl install redis-3.1.4 \
	&& docker-php-ext-enable redis
