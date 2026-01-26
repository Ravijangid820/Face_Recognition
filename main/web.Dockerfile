FROM php:8.0-apache

# Install dependencies and PHP extensions for MySQL
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     default-mysql-client \
     libzip-dev \
     libonig-dev \
     libxml2-dev \
     unzip \
  && docker-php-ext-install pdo pdo_mysql mysqli \
  && a2enmod rewrite \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
