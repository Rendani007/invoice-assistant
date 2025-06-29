FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev npm nodejs \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN npm ci && npm run build
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache
RUN chmod -R 775 storage bootstrap/cache

CMD ["sh", "./start.sh"]
