# php-base-image
PHP base docker image. It can be used to containerize laravel and other php projects.

# How to use

You can create a Dockerfile based on this image like this:

```Dockerfile
# Check https://hub.docker.com/r/sajjadg/php-base-image/tags for different tags
FROM php-base-image:php8.1-fpm-node18

WORKDIR /var/www/html/

# Copy composer files and install packages
COPY composer.* /var/www/html/
RUN composer install --no-scripts --no-autoloader --no-dev --no-interaction --prefer-dist

# Copy the source files
COPY . .

# Run command you need to make you deployment ready for production
RUN mkdir -p bootstrap/cache \
  && chgrp -R www-data storage bootstrap/cache \
  && chmod -R ug+rwx storage bootstrap/cache \
  && composer dump-autoload --optimize
```
