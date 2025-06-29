FROM php:8.2-fpm

# Install system deps
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev

# Install Node.js LTS (18.x)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Add Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy app code
COPY . .

# Laravel & frontend build
RUN composer install --no-dev --optimize-autoloader
RUN npm ci && npm run build
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

# Fix storage permissions
RUN chmod -R 775 storage bootstrap/cache

# Ensure logs exist
RUN mkdir -p storage/logs && touch storage/logs/laravel.log

# Run via script
CMD ["sh", "./start.sh"]
