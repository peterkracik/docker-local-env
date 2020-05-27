FROM php:7.3.8-fpm

ENV PS1="\u@\h:\w\\$ "

RUN apt-get update && apt-get upgrade -yy \
    && apt-get install --no-install-recommends libjpeg-dev libpng-dev libwebp-dev \
    libzip-dev libfreetype6-dev supervisor zip \
    unzip software-properties-common -yy \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install mbstring gd mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr --with-webp-dir=/usr \
    && docker-php-ext-install -j "$(nproc)" gd

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

CMD ["php-fpm"]

