FROM debian:jessie

#Fix to prevent Fetch errors on Apt
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

# persistent / runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      librecode0 \
      libmysqlclient-dev \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

# phpize deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      autoconf \
      file \
      g++ \
      gcc \
      libc-dev \
      make \
      pkg-config \
      re2c \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

ENV GPG_KEYS 0B96609E270F565C13292B24C13C70B87267B52D 0A95E9A026542D53835E3F3A7DEC4E69FC9C83D7 0E604491
RUN set -xe \
  && for key in $GPG_KEYS; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done


# compile openssl, otherwise --with-openssl won't work
RUN OPENSSL_VERSION="1.0.1e" \
      && cd /tmp \
      && mkdir openssl \
      && curl -sL "https://www.openssl.org/source/old/1.0.1/openssl-$OPENSSL_VERSION.tar.gz" -o openssl.tar.gz \
      && tar -xzvf openssl.tar.gz -C /tmp/openssl --strip-components=1 \
      && cd /tmp/openssl \
      && ./config --prefix=/usr/local/ssl_compiled/openssl --openssldir=/usr/local/ssl_compiled/openssl shared zlib && make && make install_sw

#RUN OPENSSL_VERSION="0.9.8zg" \
#      && cd /tmp \
#      && mkdir openssl \
#      && curl -sL "https://www.openssl.org/source/old/0.9.x/openssl-$OPENSSL_VERSION.tar.gz" -o openssl.tar.gz \
#      && curl -sL "https://www.openssl.org/source/old/0.9.x/openssl-$OPENSSL_VERSION.tar.gz.asc" -o openssl.tar.gz.asc \
#      && gpg --verify openssl.tar.gz.asc \
#      && tar -xzf openssl.tar.gz -C openssl --strip-components=1 \
#      && cd /tmp/openssl \
#      && ./config && make && make install


#RUN ls -alF /usr/local/ssl_compiled/openssl && sleep 90
#RUN find /usr/local/ssl_compiled/openssl -regex .*evp.* && sleep 90

#Install LibXML2
RUN cd /tmp \
	&& mkdir libxml2 \ 
	&& curl -sL "http://xmlsoft.org/sources/libxml2-2.7.6.tar.gz" -o libxml2.tar.gz \
	&& tar -xzvf libxml2.tar.gz -C /tmp/libxml2 --strip-components=1 \
	&& cd /tmp/libxml2 \
	&& ./configure --prefix=/usr && make && make install

RUN find /tmp/openssl

ENV PHP_VERSION 5.3.3
# php 5.3 needs older autoconf
# --enable-mysqlnd is included below because it's harder to compile after the fact the extensions are (since it's a plugin for several extensions, not an extension in itself)
RUN buildDeps=" \
                apache2-dev \
                autoconf2.13 \
                libcurl4-openssl-dev \
                openssl \
                g++ \
                libsasl2-dev \
                libreadline6-dev \
                librecode-dev \
                libsqlite3-dev \
                libpng-dev \
                xz-utils \
		pkg-config \
      " \
      && set -x \
      && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
      && curl -SL "http://museum.php.net/php5/php-$PHP_VERSION.tar.gz" -o php.tar.xz \
      && mkdir -p /usr/src/php \
      && tar -xof php.tar.xz -C /usr/src/php --strip-components=1 \
      && rm php.tar.xz* \
      && cd /usr/src/php \
	  && ldconfig -v \ 
	  && curl -SL "https://gist.githubusercontent.com/sidgwick/ebe99cd7fd0da1b648dbfc073713cd69/raw/81b2f89eef2041e46e290f00e6ae38a277e8b252/php-5.3.3%2520libxml2%2520patch" -o patch_libxml2.patch \
	  && patch -p1 < ./patch_libxml2.patch \
          && ./configure \
            --disable-cgi \
#            $(command -v apxs2 > /dev/null 2>&1 && echo '--with-apxs2=/usr/bin/apxs2' || true) \
            --with-libdir=/lib/x86_64-linux-gnu \
            --with-config-file-path="$PHP_INI_DIR" \
            --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
            --with-libxml-dir=/usr \
            --enable-mbstring \
            --enable-mysqlnd \
            --with-mysql \
	    --with-gettext \
            --with-mysqli \
            --with-pdo-mysql \
            --with-curl \
            --enable-soap \
            --with-png \
            --with-gd \
            --with-readline \
            --with-recode \
            --with-zlib \
	    --with-openssl \
            --with-openssl-dir=/tmp/openssl \
      && make -j"$(nproc)" \
      && CXX=g++ make install \
      && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
      && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps \
      && make clean

WORKDIR /var/www/html

CMD ["php"]