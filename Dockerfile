FROM php:8.2-fpm-alpine

RUN apk add --no-cache nodejs npm

WORKDIR /var/www

COPY . .
RUN npm install && npm run build

RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
